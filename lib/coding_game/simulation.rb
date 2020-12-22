# require 'benchmark'

module CodingGame
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
            @saved_best_paths = []
        end

        def clear_saved_paths
            @saved_best_paths = []
        end

        def recalculate_saved_paths shifted_spells
            STDERR.puts "shifted_spells = #{shifted_spells.map{|spell| spell.id}}"
            new_saved_paths = []
            if shifted_spells.count == 0
                @saved_best_paths.each do |save_path|
                    if save_path['path'].first.nil?
                        new_saved_paths.push save_path
                    elsif save_path['path'].first.castable == false
                        save_path['steps_count'] -= 1
                        new_saved_paths.push save_path
                    end
                end
            else
                @saved_best_paths.each do |save_path|
                    new_shifted_spells = save_path['path'].shift shifted_spells.count
                    if new_shifted_spells.map{|spell| spell.id} == shifted_spells.map{|spell| spell.id}
                        save_path['steps_count'] -= 1
                        new_saved_paths.push save_path
                    end
                end
            end
            @saved_best_paths = new_saved_paths
        end

        def change_saved_paths brew_id, path
            if path['best_delta'].find{|ing| ing < 0}.nil? == false
                return path
            end
            STDERR.puts "change_saved_paths"
            s_p = @saved_best_paths.map do |_path|
                {'spells' => _path['path'].map{|spell| spell.id}, 'brew_id' => _path['brew_id'], 'steps_count' => _path['steps_count']}
            end
            STDERR.puts "@saved_best_paths = #{s_p}"
            saved_path = @saved_best_paths.find{|saved_p| brew_id == saved_p['brew_id']}
            STDERR.puts "brew_id = #{brew_id} #{saved_path.nil?.to_s} "
            if saved_path.nil? == false && saved_path['steps_count'] <= path['steps_count']
                STDERR.puts "saved_path['steps_count'] = #{saved_path['steps_count']}"
                return {'path' => saved_path['path'].clone, 'steps_count' => saved_path['steps_count'], 'best_delta' => saved_path['best_delta'].clone}
            end
            
            if saved_path.nil? == false
                @saved_best_paths = @saved_best_paths.map do |_path|
                    if brew_id == _path['brew_id']
                        _path = {'path' => path['path'].clone, 'steps_count' => path['steps_count'], 'best_delta' => path['best_delta'].clone, 'brew_id' => brew_id}
                    end
                    _path
                end
            else
                new_path = {'path' => path['path'].clone, 'steps_count' => path['steps_count'], 'best_delta' => path['best_delta'].clone, 'brew_id' => brew_id}
                @saved_best_paths.push(new_path)
            end

            return path
        end

        def learn_max_tome_index
            tome_index = @my_ings[0]
            tome_index = 5 if tome_index > 5
            learn = @spells.find{|spell| spell.type == 'LEARN' && spell.tome_index == tome_index}
            puts "LEARN #{learn.id}"
        end

        def cur_brews_ids
            @brews.map {|brew| brew["id"]}
        end

        def try_cast spell, value
            if spell.castable
                puts "CAST #{spell.id} #{value}"
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

        def get_best_learns
            filtered_spells = []
            only_positive_spells = @spells.reject{|spell| spell.ings.find{|ing| ing < 0}}
            casts = only_positive_spells.select{|spell| spell.type == 'CAST' && spell.active == true}
            learns = only_positive_spells.select{|spell| spell.type == 'LEARN' && spell.active == true}
            if casts.find{|spell| spell.ings == [4,0,0,0]}
                learns = learns.reject{|spell| spell.ings == [3,0,0,0]}
            end
            learns
            # learns.each do |spell_1|
            #     good_learn = false
            #     casts.each do |spell_2|
            #         delta = get_delta(spell_1.ings, spell_2.ings.map {|ing| -ing})
            #         if delta.find {|ing| ing < 0}.nil?
            #             good_learn = true
            #             break
            #         end
            #     end
            #     if good_learn
            #         filtered_spells.push(spell_1)
            #     end
            # end
            # filtered_spells
        end
        
        def spells_optimization spells
            filtered_spells = spells.select{|spell| spell.ings.find{|ing| ing < 0}}
            spells = spells.reject{|spell| spell.ings.find{|ing| ing < 0}}
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

        def build_tree ings_state, max_steps_level = 8, timeout = 0.045
            filter_spells
            @tree = SpellTree.new @filtered_spells
            @tree.timeout = timeout
            @tree.root.ings_state = ings_state
            @tree.max_steps_level = max_steps_level
            @tree.root.used_spells = @filtered_spells.select{|spell| spell.type == 'CAST' && spell.castable == false}
            @tree.states_history[ings_state.to_s] = @tree.root
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
            path_algorithm3 brew_ings
            # path_algorithm1 brew_ings, cur_ings
        end

        def path_algorithm3 brew_ings
            max_negatives_sum = -100
            min_steps = 100
            spells = []
            best_node = nil
            best_delta = []
            best_sum_positive= -1
            @tree.states_history.each do |state, node|
                delta_result = @tree.get_delta(brew_ings, node.ings_state)
                sum_negatives = delta_result.select{|ing| ing < 0}.sum
                sum_positive = delta_result.select{|ing| ing > 0}.sum
                if sum_negatives == 0
                    if max_negatives_sum < 0
                        max_negatives_sum = sum_negatives
                        best_sum_positive = sum_positive
                        best_node = node
                        min_steps = node.steps_with_rest_count
                        best_delta = delta_result
                    else
                        if min_steps > node.steps_with_rest_count
                            max_negatives_sum = sum_negatives
                            best_sum_positive = sum_positive
                            best_node = node
                            min_steps = node.steps_with_rest_count
                            best_delta = delta_result
                        elsif min_steps == node.steps_with_rest_count && sum_positive > best_sum_positive
                            max_negatives_sum = sum_negatives
                            best_sum_positive = sum_positive
                            best_node = node
                            min_steps = node.steps_with_rest_count
                            best_delta = delta_result
                        end
                    end
                else
                    if sum_negatives > max_negatives_sum
                        max_negatives_sum = sum_negatives
                        best_sum_positive = sum_positive
                        best_node = node
                        min_steps = node.steps_with_rest_count
                        best_delta = delta_result
                    elsif sum_negatives == max_negatives_sum && min_steps > node.steps_with_rest_count
                        max_negatives_sum = sum_negatives
                        best_sum_positive = sum_positive
                        best_node = node
                        min_steps = node.steps_with_rest_count
                        best_delta = delta_result
                    end
                end
            end
            steps_with_rest_count = best_node.steps_with_rest_count
            while !best_node.parent.nil?
                spells.push(best_node.spell)
                best_node = best_node.parent
            end
            {'path' => spells.reverse, 'steps_count' => steps_with_rest_count, 'best_delta' => best_delta}
        end

        def path_algorithm2 brew_ings
            nodes = []

            @tree.states_history.each do |state, node|
                nodes.push(node)
            end
            nodes = nodes.sort_by{|node| node.steps_with_rest_count}
            flag = true
            best_node = nil
            nodes.each do |node|
                if best_node && best_node.steps_with_rest_count < node.steps_with_rest_count
                    break
                end
                if @tree.get_delta(brew_ings, node.ings_state).find {|el| el < 0}.nil?
                    if best_node.nil?
                        best_node = node
                    elsif best_node.steps_with_rest_count == node.steps_with_rest_count
                        delta1 = @tree.get_delta(brew_ings, node.ings_state)
                        delta2 = @tree.get_delta(brew_ings, best_node.ings_state)
                        if delta1.sum > delta2.sum
                            best_node = node
                        elsif delta1.sum == delta2.sum
                            delta3 = @tree.get_delta(delta1, delta2.map{|ing| -ing})
                            index1 = delta3.find{|ing| ing < 0}
                            index2 = delta3.find{|ing| ing > 0}
                            if index1 && index2 && index1 > index2
                                best_node = node
                            end
                        end
                    end
                end
            end
            return {'path' => [], 'steps_count' => 0} if best_node.nil?
            spells = []
            steps_with_rest_count = best_node.steps_with_rest_count
            while !best_node.parent.nil?
                spells.push(best_node.spell)
                best_node = best_node.parent
            end
            {'path' => spells.reverse, 'steps_count' => steps_with_rest_count}
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
            MAX_INGS_COUNT = 10

            attr_accessor :root, :spells, :states_history, :counter, :start_time, :max_steps_level, :timeout

            def initialize spells
                @max_steps_level = 6
                @root = Node.new nil, nil, [0,0,0,0]
                @spells = spells
                @states_history = {}
            end

            def build_tree parent_node
                if Time.now - @start_time > @timeout
                    return
                end
                possible_spells = get_possible_spells(parent_node)
                possible_spells.each do |possible_spell|
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
                if possible_spell["spell"].repeatable && parent_node.spell && parent_node.spell.id == possible_spell["spell"].id
                    node.steps_with_rest_count = parent_node.steps_with_rest_count
                    node.used_spells = parent_node.used_spells.clone
                else
                    if need_rest(parent_node, possible_spell["spell"].id)
                        node.used_spells = []
                        node.steps_with_rest_count = parent_node.steps_with_rest_count + 2
                    else
                        node.steps_with_rest_count = parent_node.steps_with_rest_count + 1
                        node.used_spells = parent_node.used_spells.clone
                    end
                    node.used_spells.push node.spell
                end
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
                return [] if node.steps_with_rest_count > @max_steps_level
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
                attr_accessor :parent, :children, :spell, :ings_state, :steps_with_rest_count, :used_spells, :name, :level
                def initialize spell, parent, ings_state
                    @parent = parent
                    @spell = spell
                    @ings_state = ings_state
                    @children = []
                    @level = 0
                    if parent.nil?
                        @steps_with_rest_count = 0
                        @used_spells = []
                        @name = '*ROOT*'
                    else
                        @level = @parent.level + 1
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
end
