
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
    {
        'id' => 5,
        'ings' => [0,0,2,0]
    }
]

brew = [0, 0, -2, -2]
my_inv = [3, 0, 0, 0]
@recursion_level = 0

def find_optimal_paths delta_inventory
	#p delta_inventory
	@recursion_level += 1
	need_ing = delta_inventory.index { |ing| ing < 0 }
	#p need_ing
	if need_ing.nil?
		@recursion_level -= 1
		return {
			'path' => [],
			'ingredients' => []
		}
	end
	needed_spells = get_needed_spells need_ing
	#p needed_spells
	all_paths = needed_spells.map do |needed_spell|
		current_delta_inventory = delta_inventory.map { |x| x }
		negative_ings_values = delta_inventory.map { |x| x < 0 ? x : 0 }
		current_ing_only = delta_inventory.each_with_index.map { |x,i| need_ing == i ? x : 0 }
		positive_ings = current_delta_inventory.each_with_index.map { |x,i| need_ing == i || x < 0 ? 0 : x }
		spell_positive_ings = needed_spell["ings"].map { |x| x > 0 ? x : 0 }
		result_info = find_optimal_paths(get_delta(needed_spell["ings"].map { |x| x > 0 ? 0 : x }, positive_ings))
		{
			'path' => result_info["path"] + [needed_spell],
			'ingredients' => get_delta(result_info["ingredients"], negative_ings_values, current_ing_only, spell_positive_ings)
		}
	end
	optimal_path_info = nil
	p "R_L #{@recursion_level}"
	p all_paths
	all_paths.each do |path_info|
		result_info = find_optimal_paths path_info["ingredients"]
		result_path = path_info["path"] + result_info["path"]
		if optimal_path_info.nil? || optimal_path_info["path"].count > result_path.count
			optimal_path_info = {
				"path" => result_path,
				"ingredients" => result_info["ingredients"]
			}
		end
	end
	@recursion_level -= 1
	return optimal_path_info
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

idx = find_optimal_paths(get_delta(my_inv, brew))
