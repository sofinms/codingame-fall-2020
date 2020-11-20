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

    def find_sum_ings i1, i2
        r = []
        i1.each_with_index do |v,k|
            r.push(v+i2[k])
        end
        r
    end

    def find_need_zelies ing
        @zels.select{|zel| zel['ings'][ing] > 0}
    end

    def can_i_use_zel_now zel, storage
        st = find_sum_ings zel['ings'], storage
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
                storage = find_sum_ings(need_zel['ings'], clear_storage)
            else
                # STDERR.puts ttt + "can_i #{can_i} --\n"
                st = clear_storage.map{|_e| _e}
                pp = []
                # STDERR.puts ttt + "befor while st = #{st} --\n"
                while st[need_ing] < 0 do
                    need_ing_val = st[need_ing]
                    st[need_ing] = 0
                    st = find_sum_ings(st, need_zel['ings'].map{|_e| r = _e; r = 0 if r > 0; r})
                    result = find_path(st)
                    pp = pp + result['paths'] + [need_zel['id']]
                    st = find_sum_ings(result['storage'], need_zel['ings'].map{|_e| r = _e; r = 0 if r < 0; r})
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
        storage = find_sum_ings(storage, other_minuses)
        result = find_path storage
        storage = result['storage']
        best_paths += result['paths']
        a = {'storage' => storage, 'paths' => best_paths}
        # STDERR.puts ttt + "#{a}\n"
        @tabs -= 1
        {
            'storage' => storage,
            'paths' => best_paths
        }
    end
end

bot = Bot.new

# game loop
my_info = {
    'inv_0' => 0,
    'inv_1' => 0,
    'inv_2' => 0,
    'inv_3' => 0,
    'score' => 0
}
him_info = {
    'inv_0' => 0,
    'inv_1' => 0,
    'inv_2' => 0,
    'inv_3' => 0,
    'score' => 0
}

def get_max_price_brews brews
    brews.sort_by{ |h| -h['price'] }.first
end

def get_minus_ingredients deltas
    pairs = []
    deltas.each_with_index do |v,i|
        if v < 0
            pairs.push [i,v.abs]
        end
    end
    pairs
end

def get_plus_ingredients deltas
    pairs = []
    deltas.each_with_index do |v,i|
        if v > 0
            pairs.push [i,v]
        end
    end
    pairs
end
first_iteration = true
loop do
    brews = []
    zels = []
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
            brews.push ({
                'id' => action_id,
                'price' => price,
                'ings' => [delta_0, delta_1, delta_2, delta_3]
            })
        when 'CAST'
            deltas = 
            zels.push(
                {
                    'id' => action_id,
                    'ings' => [delta_0, delta_1, delta_2, delta_3],
                    'castable' => castable
                }
            )
        end
    end
    bot.set_zels zels
    
    my_info['inv_0'], my_info['inv_1'], my_info['inv_2'], my_info['inv_3'], my_info['score'] = gets.split(" ").collect { |x| x.to_i }
    him_info['inv_0'], him_info['inv_1'], him_info['inv_2'], him_info['inv_3'], him_info['score'] = gets.split(" ").collect { |x| x.to_i }

    my_ings = [my_info['inv_0'], my_info['inv_1'], my_info['inv_2'], my_info['inv_3']]
    max_price_brew = get_max_price_brews brews
    
    STDERR.puts my_ings.to_s
    STDERR.puts max_price_brew['ings'].to_s
    if !first_iteration
        
    end
    storage_after_zel = bot.find_sum_ings(my_ings, max_price_brew['ings'])
    if storage_after_zel.select{|_e| _e < 0}.first.nil?
        puts "BREW #{max_price_brew['id']}"
    else
        path = bot.find_path storage_after_zel
        my_zel = zels.select{|_e| _e['id'] == path['paths'].first}.first
        STDERR.puts my_zel
        if my_zel['castable']
            puts "CAST #{my_zel['id']}"
        else
            puts "REST" 
        end
    end

    # in the first league: BREW <id> | WAIT; later: BREW <id> | CAST <id> [<times>] | LEARN <id> | REST | WAIT
    
    # STDERR.puts
    first_iteration = false
end