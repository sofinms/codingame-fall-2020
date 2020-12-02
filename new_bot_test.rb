require 'benchmark'

time = Benchmark.measure do
	@spells = [
	    {
	        'id' => 1,
	        'ings' => [2,0,0,0]
	    },
	    {
	        'id' => 2,
	        'ings' => [-1,1,0,0]
	    },
	    {
	        'id' => 3,
	        'ings' => [0,-1,1,0]
	    },
	    {
	        'id' => 4,
	        'ings' => [0,0,-1,1]
	    },
	    # {
	    #     'id' => 5,
	    #     'ings' => [0,0,2,0]
	    # }
	    {
	        'id' => 5,
	        'ings' => [-3,1,1,0]
	    },
	    {
	        'id' => 6,
	        'ings' => [1,0,1,0]
	    },
	    {
	        'id' => 7,
	        'ings' => [2,2,0,-1]
	    },
	    {
	        'id' => 8,
	        'ings' => [3,0,1,-1]
	    },
	    {
	        'id' => 9,
	        'ings' => [2,-3,2,0]
	    },
	    {
	        'id' => 10,
	        'ings' => [-4,0,2,0]
	    }
	]

	brew = [0, 0, -2, -2]
	my_inv = [3, 0, 0, 0]
	@recursion_level = 0

	def find_optimal_paths delta_inventory, used_spells
		@recursion_level += 1
		tabs = (1..@recursion_level).to_a.map{|_e| "\s"}.join
		STDERR.puts tabs + "@#{@recursion_level}\n"
		if @recursion_level > 5
			@recursion_level -= 1
			return nil
		end
		
		need_ing = delta_inventory.index { |ing| ing < 0 }
		if need_ing.nil?
			info = {
				'path' => [],
				'ingredients' => delta_inventory,
				'used_spells' => used_spells.clone
			}
			@recursion_level -= 1
			return info
		end
		needed_spells = get_needed_spells need_ing
		needed_spells = needed_spells.reject{|_sp| used_spells.include? _sp['id']}
		STDERR.puts tabs + "used_spells = #{used_spells}\n"
		STDERR.puts tabs + "needed_spells = #{needed_spells.map{|_e| _e['id']}}\n"
		all_paths = []
		needed_spells.each do |needed_spell|
			new_used_spells = used_spells.clone
			new_used_spells.push needed_spell['id']
			check_delta = get_delta(delta_inventory, needed_spell["ings"])
			#STDERR.puts tabs + "check_delta = #{check_delta}"
			current_delta_inventory = delta_inventory.map { |x| x }
			negative_ings_values = delta_inventory.map { |x| x < 0 ? x : 0 }
			positive_ings = current_delta_inventory.each_with_index.map { |x,i| need_ing == i || x < 0 ? 0 : x }
			spell_positive_ings = needed_spell["ings"].map { |x| x > 0 ? x : 0 }
			# STDERR.puts tabs + "Z = #{needed_spell['id']}\n"
			result_info = find_optimal_paths(get_delta(needed_spell["ings"].map { |x| x > 0 ? 0 : x }, positive_ings), new_used_spells)
			next if result_info.nil?

			all_paths.push({
				'path' => result_info["path"] + [needed_spell],
				'ingredients' => get_delta(result_info["ingredients"], negative_ings_values, spell_positive_ings),
				'used_spells' => result_info['used_spells']
			})
		end
		all_paths = all_paths_filter(all_paths)

		optimal_path_info = nil
		all_paths.each do |path_info|
			#STDERR.puts tabs + "path_info['ingredients'] = #{path_info['ingredients']}"
			result_info = find_optimal_paths path_info["ingredients"], []
			next if result_info.nil?
			result_path = path_info["path"] + result_info["path"]
			if optimal_path_info.nil? || optimal_path_info["path"].count > result_path.count
				optimal_path_info = {
					"path" => result_path,
					"ingredients" => result_info["ingredients"],
					"used_spells" => result_info['used_spells'].clone
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
			p all_paths[index]['ingredients']
			((index+1)..all_paths.count - 1).each do |compare_index|
				p all_paths[compare_index]['ingredients']
				next if all_paths[compare_index]['rejected'] == true
				if all_paths[compare_index]['ingredients'][0] <= all_paths[index]['ingredients'][0] && all_paths[compare_index]['ingredients'][1] <= all_paths[index]['ingredients'][1] && all_paths[compare_index]['ingredients'][2] <= all_paths[index]['ingredients'][2] && all_paths[compare_index]['ingredients'][3] <= all_paths[index]['ingredients'][3]
					all_paths[compare_index]['rejected'] = true
				end
			end
			index += 1
		end
		all_paths.reject{|_path| _path['rejected']}
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

	def get_needed_spells idx
		variants = []
		@spells.each do |spell|
			if spell["ings"][idx] > 0
				variants.push(spell)
			end
		end
		variants
	end

	delta = get_delta(my_inv, brew)
	idx = find_optimal_paths(delta, [])
	p idx
end
puts time
