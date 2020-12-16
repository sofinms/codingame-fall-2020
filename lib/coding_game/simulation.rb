# require 'benchmark'

module CodingGame
    class Simulation
        attr_accessor :spells, :needed_spells, :tree
        def initialize()
            @spells = []
            @needed_spells = []
            @tree = SpellTree.new @spells
        end
        def disactivate_spells
            @spells.each do |spell|
                spell.active = false
            end
        end
        def build_tree
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

        def get_shortest_path brew_ings, cur_ings
            paths = []
            @tree.states_history.each do |state, value|
              paths.push({
                'level' => value.level,
                'node' => value
              })
            end
            paths = paths.sort_by{|x| x["level"]}
            optimal_steps = []
            optimal_paths = paths.select {|path| @tree.get_delta(brew_ings, path["node"].ings_state).find {|el| el < 0}.nil? }.first(3).each do |optimal_path|
                node = optimal_path["node"]
                steps = []
                first_iteration = true
                all_spells_ings = [brew_ings]
                while !node.parent.nil?
                    if node.spell
                        steps.push(node.spell)
                        all_spells_ings.unshift(node.spell.ings)
                        my_inv = cur_ings.clone
                        if can_brew(all_spells_ings, my_inv)
                            break
                        end
                    end
                    node = node.parent
                end
                if optimal_steps.count == 0 || optimal_steps.count > steps.count
                    optimal_steps = steps.clone
                end
            end
            optimal_steps.reverse
        end

        # class Brew
        #     attr_accessor :id, :type, :ings

        #     def initialize(id, ings)
        #         @id = id
        #         @ings = ings
        #         @type = 'BREW'
        #     end
        # end

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
            attr_reader :root, :spells, :states_history
            def initialize spells
                @root = Node.new nil, nil, [0,0,0,0]
                @spells = spells
                @states_history = {}
            end
            def build_tree node
                get_possible_spells(node).each do |possible_spell|
                    if @states_history[possible_spell["state_ings"].to_s].nil?
                        new_node = add_node node, possible_spell
                        @states_history[possible_spell["state_ings"].to_s] = new_node
                        build_tree new_node
                    elsif node.level + 1 < @states_history[possible_spell["state_ings"].to_s].level
                        # @states_history[possible_spell["state_ings"].to_s].parent.children = @states_history[possible_spell["state_ings"].to_s].parent.children.reject { |child| child.spell && child.spell.id ==  @states_history[possible_spell["state_ings"].to_s].spell.id }
                        clear_history @states_history[possible_spell["state_ings"].to_s]
                        new_node = add_node node, possible_spell
                        @states_history[possible_spell["state_ings"].to_s] = new_node
                        build_tree new_node
                    else
                        new_node = add_node node, possible_spell
                    end
                end
            end
            def add_node parent_node, possible_spell
                parent = parent_node
                if need_rest parent_node, possible_spell["spell"].id
                    parent = SpellTree::Node.new nil, parent_node, parent_node.ings_state
                    parent_node.children.push(parent)
                    parent.used_spells = []
                end
                new_node = SpellTree::Node.new possible_spell["spell"], parent, possible_spell["state_ings"]
                parent.children.push(new_node)
                new_node
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
                return [] if node.level > 11
                possible_spells = []
                @spells.each do |spell|
                    delta = get_delta(node.ings_state, spell.ings)
                    if delta.find {|x| x < 0}.nil? && delta.sum <= 10
                        possible_spells.push({"spell" => spell, "state_ings" => delta})
                    end
                end
                possible_spells
            end
            def need_rest node, possible_spell_id
                node.used_spells.find { |x| x.id == possible_spell_id }
            end
            def clear_history removed_node
                @states_history.delete(removed_node.ings_state.to_s)
                removed_node.children.each do |removed_child|
                    clear_history removed_child
                end
            end
            class Node
                attr_accessor :parent, :children, :spell, :ings_state, :level, :used_spells
                def initialize spell, parent, ings_state
                    @parent = parent
                    @spell = spell
                    @ings_state = ings_state
                    @children = []
                    if parent.nil?
                        @level = 0
                        @used_spells = []
                    else
                        @level = parent.level + 1
                        @used_spells = parent.used_spells.clone
                        @used_spells.push(spell)
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
