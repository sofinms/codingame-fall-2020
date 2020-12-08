STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.
class Simulation
    attr_accessor :spells, :needed_spells
    
    def initialize()
        @spells = []
        @needed_spells = []
    end

    def disactivate_spells
        @spells.each do |spell|
            spell.active = false
        end
    end

    def find_spell_by_ings ings
        @spells.find{|_sp| _sp.ings == ings}
    end

    def get_learns
        @spells.select{|spell| spell.type == 'LEARN'}
    end

    def get_casts
        @spells.select{|spell| spell.type == 'CAST'}
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

        def find_path delta_inventory, used_spells, needed_spells, prev_ings
            max_tome_index = @spells.select{|sp| sp.active == true}.sort_by{|sp| ind = sp.tome_index; ind = -1 if ind.nil?; ind;}[0..11].last.tome_index
            @needed_spells[0] = needed_spells[0].select{|spell| spell.active == true}.reject{|spell| spell.tome_index && spell.tome_index > max_tome_index}
            @needed_spells[1] = needed_spells[1].select{|spell| spell.active == true}.reject{|spell| spell.tome_index && spell.tome_index > max_tome_index}
            @needed_spells[2] = needed_spells[2].select{|spell| spell.active == true}.reject{|spell| spell.tome_index && spell.tome_index > max_tome_index}
            @needed_spells[3] = needed_spells[3].select{|spell| spell.active == true}.reject{|spell| spell.tome_index && spell.tome_index > max_tome_index}
            @start_time = Time.now
            return find_optimal_path delta_inventory, used_spells, prev_ings
        end

        def find_optimal_path delta_inventory, used_spells, prev_ings
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
                    'ings_path' => [],
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
                spell_positive_ings = []
                spell_negative_ings = []
                possible_ings = []
                needed_spell.ings.each_with_index do |x, key|
                    positive_val = x > 0 ? x : 0
                    negative_val = x > 0 ? 0 : x
                    if delta_inventory[key] > 0 && prev_ings[key] < 0 && positive_val > 0
                        possible_ings.push(positive_val)
                        positive_val = 0
                    else
                        possible_ings.push(0)
                    end
                    spell_negative_ings.push(negative_val)
                    spell_positive_ings.push(positive_val)
                end
                result_info = find_optimal_path(get_delta(spell_negative_ings, positive_ings, possible_ings), new_used_spells, spell_negative_ings)
                next if result_info.nil?

                level = result_info['level'] - @recursion_level
                type = 'CAST'
                action = Simulation::Action.new(type, needed_spell)
                all_paths.push({
                    'path' => result_info["path"] + [action],
                    'ingredients' => get_delta(result_info["ingredients"], negative_ings_values, spell_positive_ings),
                    'used_spells' => result_info['used_spells'],
                    'level' => level,
                    'ings_path' => result_info["ings_path"] + [get_delta(result_info["ingredients"], spell_positive_ings)]
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
                result_info = find_optimal_path path_info["ingredients"], [], prev_ings
                next if result_info.nil?
                result_path = path_info["path"] + result_info["path"]
                result_ings_path = path_info["ings_path"] + result_info["ings_path"]
                if optimal_path_info.nil? || optimal_path_info["path"].count > result_path.count
                    optimal_path_info = {
                        "path" => result_path,
                        "ingredients" => result_info["ingredients"],
                        "used_spells" => result_info['used_spells'].clone,
                        'level' => result_info["level"],
                        'ings_path' => result_ings_path
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

# game loop
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

def get_max_price_brews
    @brews.sort_by{ |h| -h['price'] }.first
end

def find_actions_path_to_brew bot, brew, simulator
    STDERR.puts "brew id = #{brew['id']}"
    storage_after_zel = Simulation::Bot.find_sum_ings(@my_ings, brew['ings'])
    STDERR.puts "storage_after_zel = #{storage_after_zel}"
    res = bot.find_path storage_after_zel, [], simulator.needed_spells, brew['ings']
    actions_path = res['path']
    path_learns = res['path'].select{|action| action.link.type == 'LEARN'}.uniq{|action| action.link.id}
    STDERR.puts "path_learns = #{path_learns.map{|action| action.link.id}}"
    if path_learns.count > 0
        learn_actions = add_learn_spells path_learns, simulator
        actions_path = learn_actions + actions_path
    end
    STDERR.puts "spell_ids = #{actions_path.map{|action| action.link.id}}"
    actions_path_with_rests = add_rest_to_path actions_path
    STDERR.puts "actions_path_with_rests = #{actions_path_with_rests.map{|action| action.type}}"
    rating = (brew['price'].to_f/actions_path_with_rests.count.to_f).to_f
    STDERR.puts "rating = #{rating}"
    STDERR.puts "--------------------"
    {
        'brew_id' => brew['id'],
        'rating' => rating,
        'path' => actions_path_with_rests
    }
end

def detect_all_brew_paths bot, simulator
    learn_ids = simulator.get_learns().map{|_learn| _learn.id}
    paths = []
    @brews.each do |brew|
        brew_path = find_actions_path_to_brew(bot, brew, simulator)
        paths.push(brew_path)
    end
    paths
end

def check_all_brew_paths bot, simulator
    brews_ids = @brews.map{|brew| brew['id']}
    STDERR.puts 'check_all_brew_paths'
    STDERR.puts "brews_ids = #{brews_ids}"
    STDERR.puts "@detected_paths = #{@detected_paths.map{|b| b['brew_id']}}"
    @detected_paths = @detected_paths.select{|brew_path| brews_ids.include?(brew_path['brew_id'])}
    STDERR.puts "@detected_paths.count = #{@detected_paths.count}"
    @detected_paths = @detected_paths.reject do |path|
        path['path'].find{|action| action.link && action.link.active == false}
    end
    STDERR.puts "@detected_paths.count = #{@detected_paths.count}"
    detected_brew_ids = @detected_paths.map{|brew_path| brew_path['brew_id']}
    STDERR.puts "detected_brew_ids = #{detected_brew_ids}"
    need_find_brews = brews_ids - detected_brew_ids
    STDERR.puts "need_find_brews = #{need_find_brews}"
    ending = Time.now
    elapsed = ending - @start_time
    STDERR.puts "elapsed4 = #{elapsed}"
    if need_find_brews.count > 0
        first_brew_id = need_find_brews.first
        brew = @brews.find{|brew| brew['id'] == first_brew_id}
        ending = Time.now
        elapsed = ending - @start_time
        STDERR.puts "elapsed5 = #{elapsed}"
        brew_path = find_actions_path_to_brew(bot, brew, simulator)
        @detected_paths.push(brew_path)
        @detected_paths = @detected_paths.sort_by{|_b| -_b['rating']}
    end
end



def add_learn_spells learn_actions, simulator
    cast_helper = simulator.find_spell_by_ings([2,0,0,0])
    learns = learn_actions.sort_by{|action| action.link.tome_index}.map{|action| action.link}
    ing1_count = 3
    actions_path = []
    index = 0
    learns.each do |learn|
        tome_index = learn.tome_index
        tome_index -= index
        ing1_count -= tome_index
        if ing1_count >= 0
            actions_path.push(Simulation::Action.new('LEARN', learn))
        end
        while ing1_count < 0
            ing1_count += 2
            actions_path.push(Simulation::Action.new('CAST', cast_helper))
        end
        index += 1
    end
    while ing1_count < 3
        ing1_count += 2
        actions_path.push(Simulation::Action.new('CAST', cast_helper))
    end
    actions_path
end

def add_rest_to_path path
    actions_path = path.map{|_e| _e.clone; _e.link.castable = true if _e.link.castable.nil?; _e;}
    result = []
    actions_path.each do |action|
        if action.type == 'LEARN'
            result.push action
            next
        end
        spell = action.link
        if spell.castable == false
            result.push(Simulation::Action.new('REST', nil))
            actions_path.each{|_e| _e.link.castable = true}
        end
        result.push(Simulation::Action.new('CAST', spell))
        spell.castable = false
    end
    result
end

first_iteration = true
simulator = Simulation.new
bot = Simulation::Bot.new(simulator.spells)
@my_ings = []
@brews = []
@detected_paths = []
loop do
    @brews = []
    simulator.disactivate_spells
    action_count = gets.to_i # the number of spells and recipes in play
    @start_time = Time.now
    action_count.times do
        # action_id: the unique ID of this spell or recipe
        # action_type: in the first league: BREW; later: CAST, OPPONENT_CAST, LEARN, BREW
        # delta_0: tier-0 ingredient change
        # delta_1: tier-1 ingredient change
        # delta_2: tier-2 ingredient change
        # delta_3: tier-3 ingredient change
        # price: the price in rupees if this is a potion
        # tome_index: in the first two leagues: always 0; later: the index in the tome if this is a tome spell, equal to the read-ahead tax; For brews, this is the value of the current urgency bonus
        # tax_count: in the first two leagues: always 0; later: the amount of taxed tier-0 ingredients you gain from learning this spell; For brews, this is how many times you can still gain an urgency bonus
        # castable: in the first league: always 0; later: 1 if this is a castable player spell
        # repeatable: for the first two leagues: always 0; later: 1 if this is a repeatable player spell
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
            @brews.push ({
                'id' => action_id,
                'price' => price,
                'ings' => [delta_0, delta_1, delta_2, delta_3]
            })
        when 'CAST', 'LEARN'
            simulator.add_spell({
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
    @my_ings = [my_info['inv_0'], my_info['inv_1'], my_info['inv_2'], my_info['inv_3']]
    
    if him_info['score'] < him_score
        him_info['brew_count'] += 1
    end
    him_info['score'] = him_score

    if first_iteration
        @detected_paths = detect_all_brew_paths bot, simulator
        @detected_paths = @detected_paths.sort_by{|_b| -_b['rating']}
    end
    check_all_brew_paths bot, simulator
    best_brew = @detected_paths.first
    STDERR.puts "best_brew = #{best_brew}"
    action = best_brew['path'].shift
    if action.nil?
        @detected_paths = @detected_paths.reject{|_path| _path['path'].count == 0}
        puts "BREW #{best_brew['brew_id']}"
    else
        case action.type
        when 'LEARN', 'CAST'
            puts "#{action.type} #{action.link.id}"
        when 'REST'
            puts 'REST'
        else
            STDERR.puts "ERROR! action type not detected"
        end
    end
    
    

    # in the first league: BREW <id> | WAIT; later: BREW <id> | CAST <id> [<times>] | LEARN <id> | REST | WAIT
    first_iteration = false
end