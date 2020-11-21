STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.


class Bot
    def initialize
        @tabs = 0
        @zels = []
    end

    def set_zels zels
        @zels = zels
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

    def find_need_zelies ing
        zels = @zels.select{|zel| zel['ings'][ing] > 0}
        zels.reject do |zel|
            big_ing = ing + 1
            res = false
            while big_ing < 4 do
                if zel['ings'][big_ing] < 0
                    res = true
                end
                big_ing += 1
            end
            res
        end
    end

    def can_i_use_zel_now zel, storage
        st = Bot.find_sum_ings zel['ings'], storage
        st.select{|_e| _e < 0}.first.nil?
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

    def find_path storage
        @tabs += 1
        ttt = (1..@tabs).to_a.map{|_e| "\s"}.join
        # STDERR.puts ttt + "Find_path for #{storage} --\n"
        need_ing = storage.index{|_e| _e < 0}
        if need_ing.nil?
            a = {
                'storage' => storage,
                'paths' => []
            }
            # STDERR.puts ttt + "#{a}\n"
            @tabs -= 1
            return a
        end
        need_zels = find_need_zelies need_ing
        best_paths = []
        clear_storage = get_storage_without_other_minuses storage, need_ing
        other_minuses = get_storage_other_minuses storage, need_ing
        # STDERR.puts ttt + "search zels for #{clear_storage} --\n"
        need_zels.each do |need_zel|
            # STDERR.puts ttt + "need_zel #{need_zel} --\n"
            can_i = can_i_use_zel_now(need_zel, clear_storage)
            if can_i
                # STDERR.puts ttt + "can_i #{can_i} --\n"
                best_paths = [need_zel['id']]
                storage = Bot.find_sum_ings(need_zel['ings'], clear_storage)
            else
                # STDERR.puts ttt + "can_i #{can_i} --\n"
                st = clear_storage.map{|_e| _e}
                pp = []
                # STDERR.puts ttt + "befor while st = #{st} --\n"
                while st[need_ing] < 0 do
                    need_ing_val = st[need_ing]
                    st[need_ing] = 0
                    st = Bot.find_sum_ings(st, need_zel['ings'].map{|_e| r = _e; r = 0 if r > 0; r})
                    result = find_path(st)
                    pp = pp + result['paths'] + [need_zel['id']]
                    st = Bot.find_sum_ings(result['storage'], need_zel['ings'].map{|_e| r = _e; r = 0 if r < 0; r})
                    st[need_ing] = st[need_ing] + need_ing_val
                end
                # STDERR.puts ttt + "after while st = #{st}, pp = #{pp}\n"

                if best_paths.count == 0 || pp.count < best_paths.count
                    storage = st
                    best_paths = pp
                end
            end
        end
        # STDERR.puts ttt + "best paths = #{best_paths}\n"
        # STDERR.puts ttt + "storage = #{storage}\n"
        storage = Bot.find_sum_ings(storage, other_minuses)
        result = find_path storage
        storage = result['storage']
        best_paths += result['paths']
        a = {'storage' => storage, 'paths' => best_paths}
        # STDERR.puts ttt + "#{a}\n"
        @tabs -= 1
        a
    end
end

bot = Bot.new

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

def get_faster_brew bot
    brews = @brews.sort_by do |brew|
        storage_after_zel = Bot.find_sum_ings(@my_ings, brew['ings'])
        res = bot.find_path storage_after_zel
        res['paths'].count
    end
    brews.first
end

def get_brew_ratings bot
    @brews.each do |brew|
        storage_after_zel = Bot.find_sum_ings(@my_ings, brew['ings'])
        res = bot.find_path storage_after_zel
        STDERR.puts "Brew #{brew['id']}, path count = #{res['paths'].count}, price = #{brew['price']}, rating = #{(brew['price'].to_f/res['paths'].count.to_f).to_f}"
        res['paths'].count
    end
end

def get_best_brew_rating bot
    brews = @brews.sort_by do |brew|
        storage_after_zel = Bot.find_sum_ings(@my_ings, brew['ings'])
        res = bot.find_path storage_after_zel
        -(brew['price'].to_f/res['paths'].count.to_f).to_f
    end
    brews.first
end

def puts_cast zel
    if (@my_ings + zel['ings']).sum > 10
        STDERR.puts 'Too many ings'
        @brews.sort_by{ |h| -h['price'] }.each do |brew|
            ings = Bot.find_sum_ings(@my_ings, brew['ings'])
            if ings.select{|_e| _e < 0}.first.nil?
                puts "BREW #{brew['id']}"
                return true
            end
        end
        @learns.reverse.each do |learn|
            ings = Bot.find_sum_ings(@my_ings, learn['ings'])
            if ings.count < 10
                puts "LEARN #{learn['id']}"
                return true
            end
        end
        return false
    else
        STDERR.puts "check for castable #{zel}"
        if zel['castable']
            puts "CAST #{zel['id']}"
        else
            puts "REST"
        end
    end
    return true
end

first_iteration = true
@learns = []
@my_ings = []
@brews = []
loop do
    @brews = []
    zels = []
    @learns = []
    action_count = gets.to_i # the number of spells and recipes in play
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
        when 'CAST'
            zels.push(
                {
                    'id' => action_id,
                    'ings' => [delta_0, delta_1, delta_2, delta_3],
                    'castable' => castable,
                    'repeatable' => repeatable
                }
            )
        when 'LEARN'
            @learns.push ({
                'id' => action_id,
                'tome_index' => tome_index,
                'tax_count' => tax_count,
                'castable' => castable,
                'repeatable' => repeatable,
                'ings' => [delta_0, delta_1, delta_2, delta_3]
            })
        end
    end
    my_info['inv_0'], my_info['inv_1'], my_info['inv_2'], my_info['inv_3'], my_info['score'] = gets.split(" ").collect { |x| x.to_i }
    him_info['inv_0'], him_info['inv_1'], him_info['inv_2'], him_info['inv_3'], him_score = gets.split(" ").collect { |x| x.to_i }
    if him_info['score'] < him_score
        him_info['brew_count'] += 1
    end
    him_info['score'] = him_score

    STDERR.puts @learns.to_s
    STDERR.puts zels.to_s
    bot.set_zels(zels + @learns)

    @my_ings = [my_info['inv_0'], my_info['inv_1'], my_info['inv_2'], my_info['inv_3']]
    STDERR.puts "Him brew count = #{him_info['brew_count']}"

    get_brew_ratings bot
    if him_info['brew_count'] < 5
        goal_brew = get_best_brew_rating bot
    else
        STDERR.puts "search faster brew"
        goal_brew = get_faster_brew bot
    end
    STDERR.puts "goal brew is #{goal_brew}"
    storage_after_zel = Bot.find_sum_ings(@my_ings, goal_brew['ings'])
    if storage_after_zel.select{|_e| _e < 0}.first.nil?
        STDERR.puts "I can brew - #{goal_brew}"
        puts "BREW #{goal_brew['id']}"
    else
        result_path_find = bot.find_path storage_after_zel
        STDERR.puts "I need ings. Path found = #{result_path_find['paths']}"
        used_learns = @learns.select{|_e| result_path_find['paths'][0..8].include? _e['id'] }
        first_used_learn = used_learns.first
        if !first_used_learn.nil?
            STDERR.puts "I need a learn - #{first_used_learn}"
            ings_for_learn = Bot.find_sum_ings(@my_ings, [-first_used_learn['tome_index'],0,0,0])
            STDERR.puts "ings for learn - #{ings_for_learn}"
            if ings_for_learn.select{|_e| _e < 0}.first.nil?
                puts "LEARN #{first_used_learn['id']}"
            else
                bot.set_zels(zels)
                res = bot.find_path ings_for_learn
                STDERR.puts "path for learn - #{res['paths']}"
                path = res['paths']
                cast_fail = true
                path.each do |zel_id|
                    my_zel = zels.select{|_e| _e['id'] == zel_id}.first
                    if puts_cast(my_zel)
                        cast_fail = false
                        break
                    else
                        STDERR.puts "Skip cast - #{my_zel}"
                    end
                end
                if cast_fail
                    puts 'REST'
                end
            end
        else
            path = result_path_find['paths']
            cast_fail = true
            path.each do |zel_id|
                my_zel = zels.select{|_e| _e['id'] == zel_id}.first
                if puts_cast(my_zel)
                    cast_fail = false
                    break
                else
                    STDERR.puts "Skip cast - #{my_zel}"
                end
            end
            if cast_fail
                puts 'REST'
            end
        end
    end

    # in the first league: BREW <id> | WAIT; later: BREW <id> | CAST <id> [<times>] | LEARN <id> | REST | WAIT
    
    # STDERR.puts
    first_iteration = false
end