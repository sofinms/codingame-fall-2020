
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
    #{
     #   'id' => 5,
      #  'ings' => [0,0,2,0]
    #},
    {
        'id' => 10,
        'ings' => [0,0,1,-1]
    },
    {
        'id' => 11,
        'ings' => [0,-1,-1,2]
    }
]

brew = [0, 0, -2, -2]
my_inv = [3, 0, 0, 0]
@recursion_level = 0

def find_optimal_paths delta_inventory, history
	@recursion_level += 1
	tabs = (1..@recursion_level).to_a.map{|_e| "\s"}.join
	STDERR.puts tabs + "Find_path for #{delta_inventory} --\n"
	need_ing = delta_inventory.index { |ing| ing < 0 }
	if need_ing.nil?
		info = {
			'path' => [],
			'ingredients' => delta_inventory,
			'history' => history.map{|x| x.clone}
		}
		STDERR.puts tabs + "#{info}\n"
		@recursion_level -= 1
		return info
	end
	needed_spells = get_needed_spells need_ing
	all_paths = []
	needed_spells.each do |needed_spell|
		new_history = history.map{|x| x.clone}
		check_delta = get_delta(delta_inventory, needed_spell["ings"])
		next if is_ingredients_in_history new_history, check_delta
		#STDERR.puts tabs + "check_delta = #{check_delta}"
		new_history.push(check_delta)
		current_delta_inventory = delta_inventory.map { |x| x }
		negative_ings_values = delta_inventory.map { |x| x < 0 ? x : 0 }
		positive_ings = current_delta_inventory.each_with_index.map { |x,i| need_ing == i || x < 0 ? 0 : x }
		spell_positive_ings = needed_spell["ings"].map { |x| x > 0 ? x : 0 }
		result_info = find_optimal_paths(get_delta(needed_spell["ings"].map { |x| x > 0 ? 0 : x }, positive_ings), new_history.map{|x| x.clone})

		# STDERR.puts tabs + "result_info['ingredients'] = #{result_info["ingredients"]}\n"
		# STDERR.puts tabs + "negative_ings_values = #{negative_ings_values}\n"
		# STDERR.puts tabs + "spell_positive_ings = #{spell_positive_ings}\n"
		# STDERR.puts tabs + "Ingredients = #{get_delta(result_info["ingredients"], negative_ings_values, spell_positive_ings)}\n"

		all_paths.push({
			'path' => result_info["path"] + [needed_spell],
			'ingredients' => get_delta(result_info["ingredients"], negative_ings_values, spell_positive_ings),
			'history' => new_history.map{|x| x.clone}
		})
	end
	optimal_path_info = nil
	all_paths.each do |path_info|
		#STDERR.puts tabs + "path_info['history'] = #{path_info['history']}"
		#STDERR.puts tabs + "path_info['ingredients'] = #{path_info['ingredients']}"
		result_info = find_optimal_paths path_info["ingredients"], path_info['history'].map{|x| x.clone}
		result_path = path_info["path"] + result_info["path"]
		if optimal_path_info.nil? || optimal_path_info["path"].count > result_path.count
			optimal_path_info = {
				"path" => result_path,
				"ingredients" => result_info["ingredients"],
				'history' => result_info['history'].map{|x| x.clone}
			}
		end
	end
	STDERR.puts tabs + "#{optimal_path_info}\n"
	@recursion_level -= 1
	return optimal_path_info
end

def is_ingredients_in_history history, ings
	!history.find { |state| state == ings }.nil?
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
idx = find_optimal_paths(delta, [delta])
p idx
