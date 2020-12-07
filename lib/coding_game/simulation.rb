# require 'benchmark'

module CodingGame
    class Simulation
        attr_accessor :spells, :needed_spells
        
        def initialize()
            @spells = []
            @needed_spells = []
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

        class Bot
            def initialize spells
                @recursion_level = 0
                @spells = spells
                @needed_spells = {}
            end

            def find_diff_ings i1, i2
                r = []
                i1.each_with_index do |v,k|
                    r.push(v-i2[k])
                end
                r
            end

            def self.find_sum_ings i1, i2
                r = []
                i1.each_with_index do |v,k|
                    r.push(v+i2[k])
                end
                r
            end

            def get_needed_spells idx
                @needed_spells[idx]
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

            def get_storage_without_other_minuses storage, ing
                r = []
                storage.each_with_index do |value, key|
                    if value < 0 && key != ing
                        value = 0
                    end
                    r.push value
                end
                r
            end

            def is_ingredients_in_history history, ings
                !history.find { |state| state == ings }.nil?
            end

            def get_storage_other_minuses storage, ing
                r = []
                storage.each_with_index do |value, key|
                    if value < 0 && key != ing
                        value = value
                    else
                        value = 0
                    end
                    r.push value
                end
                r
            end

            def find_path delta_inventory, used_spells, needed_spells
            	@needed_spells[0] = needed_spells[0].select{|spell| spell.active == true}
            	@needed_spells[1] = needed_spells[1].select{|spell| spell.active == true}
            	@needed_spells[2] = needed_spells[2].select{|spell| spell.active == true}
            	@needed_spells[3] = needed_spells[3].select{|spell| spell.active == true}
            	@start_time = Time.now
            	return find_optimal_path delta_inventory, used_spells
            end

            def find_optimal_path delta_inventory, used_spells
        		@recursion_level += 1
        		# tabs = (1..@recursion_level).to_a.map{|_e| "\s"}.join
        		# STDERR.puts tabs + "@#{@recursion_level}\n"
        		# STDERR.puts tabs + "delta_inventory = #{delta_inventory}\n"
        		if @recursion_level > 6
        			@recursion_level -= 1
        			return nil
        		end
        		
        		need_ing = delta_inventory.index { |ing| ing < 0 }
        		if need_ing.nil?
        			info = {
        				'path' => [],
        				'ingredients' => delta_inventory,
        				'used_spells' => used_spells.clone,
        				'level' => @recursion_level
        			}
        			@recursion_level -= 1
        			return info
        		end
        		needed_spells = get_needed_spells need_ing
        		needed_spells = needed_spells.reject{|_sp| used_spells.include? _sp.id}
        		# STDERR.puts tabs + "used_spells = #{used_spells}\n"
        		# STDERR.puts tabs + "needed_spells = #{needed_spells.map{|_e| _e.id}}\n"
        		all_paths = []
        		negative_ings_values = []
        		positive_ings = []
        		delta_inventory.each_with_index do |value, key|
        			negative_ings_values.push(value < 0 ? value : 0)
        			positive_ings.push(need_ing == key || value < 0 ? 0 : value)
        		end
        		needed_spells.each do |needed_spell|
        			new_used_spells = used_spells.clone
        			new_used_spells.push needed_spell.id
        			check_delta = get_delta(delta_inventory, needed_spell.ings)
        			#STDERR.puts tabs + "check_delta = #{check_delta}"
        			spell_positive_ings = []
        			spell_negative_ings = []
        			needed_spell.ings.each do |x|
        				spell_positive_ings.push(x > 0 ? x : 0)
        				spell_negative_ings.push(x > 0 ? 0 : x)
        			end			
        			result_info = find_optimal_path(get_delta(spell_negative_ings, positive_ings), new_used_spells)
        			next if result_info.nil?

        			level = result_info['level'] - @recursion_level
        			all_paths.push({
        				'path' => result_info["path"] + [needed_spell],
        				'ingredients' => get_delta(result_info["ingredients"], negative_ings_values, spell_positive_ings),
        				'used_spells' => result_info['used_spells'],
        				'level' => level
        			})
        			# if @recursion_level == 1
        	  #           ending = Time.now
        	  #           elapsed = ending - @start_time
        	  #           STDERR.puts "Find path elapsed = #{elapsed}"
        	  #           STDERR.puts "all_paths = #{all_paths.count}"
        	  #           STDERR.puts "level = #{level}"
        	  #           STDERR.puts "path_count = #{(result_info["path"] + [needed_spell]).count}"
        	  #       end
        		end
        		# all_paths = all_paths_filter(all_paths)

        		optimal_path_info = nil
        		all_paths.each do |path_info|
        			#STDERR.puts tabs + "path_info['ingredients'] = #{path_info['ingredients']}"
        			result_info = find_optimal_path path_info["ingredients"], []
        			next if result_info.nil?
        			result_path = path_info["path"] + result_info["path"]
        			if optimal_path_info.nil? || optimal_path_info["path"].count > result_path.count
        				optimal_path_info = {
        					"path" => result_path,
        					"ingredients" => result_info["ingredients"],
        					"used_spells" => result_info['used_spells'].clone,
        					'level' => result_info["level"]
        				}
        			end
        		end
        		# STDERR.puts tabs + "#{optimal_path_info}\n"
        		if optimal_path_info
        			# STDERR.puts tabs + "optimal_path_info = #{optimal_path_info['path'].map{|_e| _e['id']}}\n"
        		end
        		@recursion_level -= 1
        		return optimal_path_info
        	end

        	def all_paths_filter all_paths
        		return all_paths if all_paths.count < 2
        		all_paths = all_paths.sort_by{|_path| _path['path'].count}
        		index = 0
        		while index < all_paths.count - 1
        			((index+1)..all_paths.count - 1).each do |compare_index|
        				next if all_paths[compare_index]['rejected'] == true
        				if all_paths[compare_index]['ingredients'][0] <= all_paths[index]['ingredients'][0] && all_paths[compare_index]['ingredients'][1] <= all_paths[index]['ingredients'][1] && all_paths[compare_index]['ingredients'][2] <= all_paths[index]['ingredients'][2] && all_paths[compare_index]['ingredients'][3] <= all_paths[index]['ingredients'][3]
        					all_paths[compare_index]['rejected'] = true
        				end
        			end
        			index += 1
        		end
        		all_paths.reject{|_path| _path['rejected']}
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
