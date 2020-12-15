# require 'benchmark'

module CodingGame
    class Simulation
        attr_accessor :spells, :needed_spells, :states_history
        def initialize()
            @states_history = []
            @spells = []
            @needed_spells = []
            # add_spell({'id' => 78,'ings' => [2, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
            # add_spell({'id' => 79,'ings' => [-1, 1, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
            # add_spell({'id' => 80,'ings' => [0, -1, 1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
            # add_spell({'id' => 81,'ings' => [0, 0, -1, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
            # temporary_id = 82
            # all_learns = [[-3, 0, 0, 1],[3, -1, 0, 0],[1, 1, 0, 0],[0, 0, 1, 0],[3, 0, 0, 0],[2, 3, -2, 0],[2, 1, -2, 1],[3, 0, 1, -1],[3, -2, 1, 0],[2, -3, 2, 0],[2, 2, 0, -1],[-4, 0, 2, 0],[2, 1, 0, 0],[4, 0, 0, 0],[0, 0, 0, 1],[0, 2, 0, 0],[1, 0, 1, 0],[-2, 0, 1, 0],[-1, -1, 0, 1],[0, 2, -1, 0],[2, -2, 0, 1],[-3, 1, 1, 0],[0, 2, -2, 1],[1, -3, 1, 1],[0, 3, 0, -1],[0, -3, 0, 2],[1, 1, 1, -1],[1, 2, -1, 0],[4, 1, -1, 0],[-5, 0, 0, 2],[-4, 0, 1, 1],[0, 3, 2, -2],[1, 1, 3, -2],[-5, 0, 3, 0],[-2, 0, -1, 2],[0, 0, -3, 3],[0, -3, 3, 0],[-3, 3, 0, 0],[-2, 2, 0, 0],[0, 0, -2, 2],[0, -2, 2, 0],[0, 0, 2, -1]]
            # all_learns.each do |learn_ings|
            #     add_spell({'id' => temporary_id,'ings' => learn_ings,'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => "LEARN"})
            #     temporary_id += 1
            # end
        end

        class Brew
            attr_accessor :id, :type, :ings

            def initialize(id, ings)
                @id = id
                @ings = ings
                @type = 'BREW'
            end
        end

        class Action
            attr_accessor :type, :link

            def initialize(type, link = nil)
                @type = type
                @link = link
            end
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
            node.used_spells.map { |x| x["id"] == possible_spell_id }
        end
        def build_tree node
            get_possible_spells(node).each do |possible_spell|
                if !states_history.include? possible_spell["state_ings"]
                    parent = node
                    if need_rest node, possible_spell["spell"].id
                        parent = SpellTree::Node.new nil, node, node.ings_state
                        parent.used_spells = []
                    end
                    new_node = SpellTree::Node.new possible_spell, parent, possible_spell["state_ings"]
                    @states_history.push(possible_spell["state_ings"])
                    build_tree new_node
                end
            end 
        end
        class SpellTree
            attr_reader :root
            def initialize
                @root = Node.new nil, nil, [0,0,0,0]
            end
            class Node
                attr_accessor :parent, :children, :spell, :ings_state, :level, :used_spells
                def initialize spell, parent, ings_state
                    @parent = parent
                    @spell = spell
                    @ings_state = ings_state
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
# time = Benchmark.measure do
	
# end
