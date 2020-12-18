STDOUT.sync = true # DO NOT REMOVE

class Simulation
    OPTIMAL_PATHS_COUNT = 5

    attr_accessor :spells, :needed_spells, :tree, :filtered_spells, :use_casts_only, :paths_to_brews, :brews, :my_ings
    def initialize
        @spells = []
        @filtered_spells = []
        @needed_spells = []
        @use_casts_only = false
        @paths_to_brews = []
        @brews = []
        @my_ings = [3,0,0,0]
    end
    def cur_brews_ids
        @brews.map {|brew| brew["id"]}
    end
    def try_cast spell
        if spell.castable
            puts "CAST #{spell.id}"
            return true
        else
            puts "REST"
            return false
        end
    end
    def try_brew brew_id
        cur_brew = @brews.find {|brew| brew["id"] == brew_id}
        STDERR.puts "brew = #{cur_brew}"
        if get_delta(cur_brew["ings"], @my_ings).find {|ing| ing < 0}.nil?
            puts "BREW #{brew_id}"
            return true
        else
            return false
        end
    end
    def disactivate_spells
        @spells.each do |spell|
            spell.active = false
        end
    end
    
    def spells_optimization spells
        filtered_spells = []
        spells.each do |spell_1|
            good_spell = true
            spells.each do |spell_2|
                if spell_1.id != spell_2.id
                    delta = get_delta(spell_2.ings, spell_1.ings.map {|ing| -ing})
                    if delta.find {|ing| ing < 0}.nil?
                        good_spell = false
                        break
                    end
                end
            end
            if good_spell
                filtered_spells.push(spell_1)
            end
        end
        filtered_spells
    end
    def filter_spells
        @filtered_spells = @spells.select {|spell| spell.active}
        if @use_casts_only
            @filtered_spells = @filtered_spells.select {|spell| spell.type == "CAST"}
        end
        @filtered_spells = spells_optimization @filtered_spells
    end
    def build_tree ings_state
        filter_spells
        @tree = SpellTree.new @filtered_spells
        @tree.root.ings_state = ings_state
        @tree.start_time = Time.now
        @tree.build_tree(@tree.root)
    end

    def get_delta *args
        delta = [0,0,0,0]
        args.each do |arg_arr|
            arg_arr.each_with_index do |ing, idx|
                delta[idx] += ing
            end
        end
        delta
    end
    def can_brew spells, cur_ings
        spells.each do |spell_ings|
            cur_ings = get_delta(cur_ings, spell_ings)
            if !cur_ings.find{|x| x < 0}.nil?
                return false
            end
        end
        true
    end

    def get_all_learns
        learns = []
        @tree.states_history.each do |state, node|
            if node.spell && node.spell.type == 'LEARN'
                learns.push node.spell
            end
        end
        learns.uniq
    end

    def remove_learn learn_id
    end

    def get_steps_count_with_rests spells
        used_spells = []
        steps_count = 0
        spells.each do |spell|
            steps_count += 1
            if used_spells.include? spell.id
                used_spells = []
                steps_count += 1
            end
            used_spells.push spell.id
        end
        steps_count
    end

    def get_shortest_path brew_ings, cur_ings
        path_algorithm2 brew_ings
        # path_algorithm1 brew_ings, cur_ings
    end

    def path_algorithm2 brew_ings
        nodes = []

        @tree.states_history.each do |state, node|
            nodes.push(node)
        end
        nodes = nodes.sort_by{|node| node.steps_with_rest_count}
        node = nodes.find{|node| @tree.get_delta(brew_ings, node.ings_state).find {|el| el < 0}.nil?}
        return [] if node.nil?
        spells = []
        while !node.parent.nil?
            spells.push(node.spell)
            node = node.parent
        end
        spells.reverse
    end

    def path_algorithm1 brew_ings, cur_ings
        nodes = []
        @tree.states_history.each do |state, node|
            nodes.push(node)
        end
        nodes = nodes.sort_by{|node| node.steps_with_rest_count}
        best_nodes = []
        while best_nodes.count < OPTIMAL_PATHS_COUNT && nodes.count > 0
            node = nodes.shift
            if @tree.get_delta(brew_ings, node.ings_state).find {|el| el < 0}.nil?
                best_nodes.push node
            end
        end
        optimal_steps = []
        optimal_steps_rests_count = 0
        best_nodes.each do |node|
            spells = []
            all_spells_ings = [brew_ings]
            while !node.parent.nil?
                spells.push(node.spell)
                all_spells_ings.unshift(node.spell.ings)
                my_inv = cur_ings.clone
                if can_brew(all_spells_ings, my_inv)
                    break
                end
                node = node.parent
            end
            steps_count = get_steps_count_with_rests spells
            if optimal_steps.count == 0 || optimal_steps_rests_count > steps_count
                optimal_steps = spells.clone
                optimal_steps_rests_count = steps_count
            end
        end
        optimal_steps.reverse
    end

    class Spell
        attr_accessor :id, :learn_id, :ings, :tome_index, :tax_count, :castable, :repeatable, :active, :type

        def initialize(id, ings, type)
            @id = id
            @ings = ings
            @type = type
            @active = true
        end
    end
    class SpellTree
        MAX_STEPS_LEVEL = 8
        MAX_INGS_COUNT = 10

        attr_accessor :root, :spells, :states_history, :counter, :start_time

        def initialize spells
            @root = Node.new nil, nil, [0,0,0,0]
            @spells = spells
            @states_history = {}
        end

        def build_tree parent_node
            #if Time.now - @start_time > 0.035
                #return
            #end
            get_possible_spells(parent_node).each do |possible_spell|
                if @states_history[possible_spell["state_ings"].to_s].nil?
                    new_node = add_node parent_node, possible_spell
                    new_node.name = "#{new_node.spell.id} #{new_node.ings_state} #{new_node.steps_with_rest_count}"
                    parent_node.children.push new_node
                    @states_history[possible_spell["state_ings"].to_s] = new_node

                    build_tree new_node
                elsif parent_node.steps_with_rest_count + 1 < @states_history[possible_spell["state_ings"].to_s].steps_with_rest_count
                    @states_history.delete(possible_spell["state_ings"].to_s)      
                    new_node = add_node parent_node, possible_spell
                    new_node.name = "#{new_node.spell.id} #{new_node.ings_state} #{new_node.steps_with_rest_count}"
                    parent_node.children.push new_node
                    @states_history[possible_spell["state_ings"].to_s] = new_node

                    build_tree new_node
                else
                    # add_node parent_node, possible_spell
                end
            end
        end

        def add_node parent_node, possible_spell
            node = SpellTree::Node.new possible_spell["spell"], parent_node, possible_spell["state_ings"]
            if need_rest(parent_node, possible_spell["spell"].id)
                node.used_spells = []
                node.steps_with_rest_count = parent_node.steps_with_rest_count + 2
            else
                node.steps_with_rest_count = parent_node.steps_with_rest_count + 1
                node.used_spells = parent_node.used_spells.clone
            end
            node.used_spells.push node.spell
            return node
        end

        def get_delta *args
            delta = [0,0,0,0]
            args.each do |arg_arr|
                arg_arr.each_with_index do |ing, idx|
                    delta[idx] += ing
                end
            end
            delta
        end

        def get_possible_spells node
            return [] if node.steps_with_rest_count > MAX_STEPS_LEVEL
            possible_spells = []
            spells = @spells.select {|spell| spell.active == true }
            spells.each do |spell|
                delta = get_delta(node.ings_state, spell.ings)
                if delta.find {|x| x < 0}.nil? && delta.sum <= MAX_INGS_COUNT
                    possible_spells.push({"spell" => spell, "state_ings" => delta})
                end
            end
            possible_spells
        end

        def need_rest node, possible_spell_id
            !node.used_spells.find { |x| x.id == possible_spell_id }.nil?
        end

        def clear_history removed_node
            @states_history.delete(removed_node.ings_state.to_s)
            removed_node.children.each do |removed_child|
                clear_history removed_child
            end
        end

        class Node
            attr_accessor :parent, :children, :spell, :ings_state, :steps_with_rest_count, :used_spells, :name
            def initialize spell, parent, ings_state
                @parent = parent
                @spell = spell
                @ings_state = ings_state
                @children = []
                if parent.nil?
                    @steps_with_rest_count = 0
                    @used_spells = []
                    @name = '*ROOT*'
                else
                    @name = "#{@spell.id} #{@ings_state} #{steps_with_rest_count}"
                end
            end
        end
    end

    def add_spell spell
        prev_spell = @spells.find{|_sp| _sp.ings == spell['ings']}
        if prev_spell.nil?
            new_spell = Spell.new(spell['id'], spell['ings'], spell['type'])
            new_spell.castable = spell['castable']
            new_spell.repeatable = spell['repeatable']
            if spell['type'] == 'LEARN'
                new_spell.learn_id = spell['id']
                new_spell.tome_index = spell['tome_index']
                new_spell.tax_count = spell['tax_count']
            end
            new_spell.ings.each_with_index do |v,k|
                if v > 0
                    @needed_spells[k] = [] if @needed_spells[k].nil?
                    @needed_spells[k].push new_spell
                end
            end
            @spells.push(new_spell)
        else
            prev_spell.type = spell['type']
            prev_spell.id = spell['id']
            prev_spell.castable = spell['castable']
            prev_spell.repeatable = spell['repeatable']
            prev_spell.tome_index = spell['tome_index']
            prev_spell.tax_count = spell['tax_count']
            prev_spell.active = true
        end
    end
end

my_info = {
    'inv_0' => 0,
    'inv_1' => 0,
    'inv_2' => 0,
    'inv_3' => 0,
    'score' => 0,
    'brew_count' => 0
}
him_info = {
    'inv_0' => 0,
    'inv_1' => 0,
    'inv_2' => 0,
    'inv_3' => 0,
    'score' => 0,
    'brew_count' => 0
}

first_iteration = true
simulation = Simulation.new
simulation.paths_to_brews = []
start_learns = []
loop do
    simulation.disactivate_spells
    simulation.brews = []
    shortest_path = []
    action_count = gets.to_i # the number of spells and recipes in play
    action_count.times do
        # action_id: the unique ID of this spell or recipe
        # action_type: CAST, OPPONENT_CAST, LEARN, BREW
        # delta_0: tier-0 ingredient change
        # delta_1: tier-1 ingredient change
        # delta_2: tier-2 ingredient change
        # delta_3: tier-3 ingredient change
        # price: the price in rupees if this is a potion
        # tome_index: the index in the tome if this is a tome spell, equal to the read-ahead tax; For brews, this is the value of the current urgency bonus
        # tax_count: the amount of taxed tier-0 ingredients you gain from learning this spell; For brews, this is how many times you can still gain an urgency bonus
        # castable: 1 if this is a castable player spell
        # repeatable: 1 if this is a repeatable player spell
        action_id, action_type, delta_0, delta_1, delta_2, delta_3, price, tome_index, tax_count, castable, repeatable = gets.split(" ")
        action_id = action_id.to_i
        delta_0 = delta_0.to_i
        delta_1 = delta_1.to_i
        delta_2 = delta_2.to_i
        delta_3 = delta_3.to_i
        price = price.to_i
        tome_index = tome_index.to_i
        tax_count = tax_count.to_i
        castable = castable.to_i == 1
        repeatable = repeatable.to_i == 1

        case action_type
        when 'BREW'
            simulation.brews.push ({
                'id' => action_id,
                'price' => price,
                'ings' => [delta_0, delta_1, delta_2, delta_3]
            })
        when 'CAST', 'LEARN'
            simulation.add_spell({
                'id' => action_id,
                'ings' => [delta_0, delta_1, delta_2, delta_3],
                'castable' => castable,
                'repeatable' => repeatable,
                'tome_index' => tome_index,
                'tax_count' => tax_count,
                'type' => action_type
            })
        end
    end
    my_info['inv_0'], my_info['inv_1'], my_info['inv_2'], my_info['inv_3'], my_info['score'] = gets.split(" ").collect { |x| x.to_i }
    him_info['inv_0'], him_info['inv_1'], him_info['inv_2'], him_info['inv_3'], him_score = gets.split(" ").collect { |x| x.to_i }
    simulation.my_ings = [my_info['inv_0'], my_info['inv_1'], my_info['inv_2'], my_info['inv_3']]
    if him_info['score'] < him_score
        him_info['brew_count'] += 1
    end
    him_info['score'] = him_score

    if first_iteration
        simulation.build_tree simulation.my_ings
        simulation.brews.each do |brew|
            brew_path = simulation.get_shortest_path brew['ings'], simulation.my_ings
            start_learns += brew_path.select {|spell| spell.type == "LEARN"}
        end
        start_learns = start_learns.uniq
    end
    start_learns = start_learns.select {|spell| spell.active}.sort_by { |spell| spell.tome_index }
    if start_learns.count > 0
        STDERR.puts "Lets LEARN"
        cur_learn = start_learns.shift
        STDERR.puts "I need LEARN #{cur_learn.id}"
        if my_info['inv_0'] - cur_learn.tome_index > 0
            puts "LEARN #{cur_learn.id}"
        else
            STDERR.puts "Accumulate for LEARN #{cur_learn.id}"
            simulation.try_cast simulation.spells.find {|x| x.ings == [2,0,0,0]}
            start_learns.unshift(cur_learn)
        end
    else
        STDERR.puts "All learns learned"
        if simulation.paths_to_brews.first.nil? || !simulation.cur_brews_ids.include?(simulation.paths_to_brews.first["brew_id"])
            STDERR.puts "Rebuild tree"
            simulation.use_casts_only = true
            simulation.build_tree simulation.my_ings
            STDERR.puts "build done"
            simulation.paths_to_brews = []

            simulation.brews.each do |brew|
                path = simulation.get_shortest_path(brew["ings"], simulation.my_ings)
                if path.count > 0
                    simulation.paths_to_brews.push({
                        "brew_id" => brew["id"],
                        "path" => path,
                        "price" => brew["price"],
                        "ings" => brew["ings"],
                        "weight" => brew["price"].to_f / path.count.to_f
                    })
                end
            end
            if him_info['brew_count'] == 5 || my_info['brew_count'] == 5
                simulation.paths_to_brews = simulation.paths_to_brews.sort_by {|brew_path| brew_path["path"].count}
            else #my_info['score'] <= him_score
                simulation.paths_to_brews = simulation.paths_to_brews.sort_by {|brew_path| -brew_path["price"]}
            end
        end
        if simulation.paths_to_brews.count == 0
            simulation.try_cast simulation.spells.find {|spell| spell.ings == [2,0,0,0]}
        else
            STDERR.puts "Goal brew = #{simulation.paths_to_brews.first["brew_id"]}, #{simulation.paths_to_brews.first["ings"].to_s}"
            can_brew = simulation.get_delta(simulation.paths_to_brews.first["ings"], simulation.my_ings).find {|ing| ing < 0}.nil?
            if simulation.paths_to_brews.first["path"].count == 0 || can_brew
                if simulation.try_brew(simulation.paths_to_brews.first["brew_id"])
                    STDERR.puts "we brew #{simulation.paths_to_brews.first["brew_id"]}"
                else
                    STDERR.puts "ERROR BREW"
                end
            elsif simulation.try_cast simulation.paths_to_brews.first["path"].first
                simulation.paths_to_brews.first["path"].shift
            end
        end
    end

    # in the first league: BREW <id> | WAIT; later: BREW <id> | CAST <id> [<times>] | LEARN <id> | REST | WAIT
    first_iteration = false
end