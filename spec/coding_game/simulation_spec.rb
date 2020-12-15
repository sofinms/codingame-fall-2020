require 'coding_game/simulation'

describe "simple" do
  subject {
    CodingGame::Simulation.new
  }

  it "first test" do
    subject.add_spell({
          'id' => 78,
          'ings' => [2, 0, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 79,
          'ings' => [-1, 1, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 80,
          'ings' => [0, -1, 1, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 81,
          'ings' => [0, 0, -1, 1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 19,
          'ings' => [0, 2, -1, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 32,
          'ings' => [1, 1, 3, -2],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 26,
          'ings' => [1, 1, 1, -1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 39,
          'ings' => [0, 0, -2, 2],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
        'id' => 33,
        'ings' => [-5, 0, 3, 0],
        'castable' => true,
        'repeatable' => false,
        'tome_index' => nil,
        'tax_count' => nil,
        'type' => 'LEARN'
    })
    subject.add_spell({
        'id' => 6,
        'ings' => [2, 1, -2, 1],
        'castable' => true,
        'repeatable' => false,
        'tome_index' => nil,
        'tax_count' => nil,
        'type' => 'LEARN'
    })
    bot = CodingGame::Simulation::Bot.new(subject.spells)
    brew = CodingGame::Simulation::Brew.new(999,[-3,-1,-1,-1])
    result = bot.find_path([4,-1,-1,-1], [], subject.needed_spells, [-3,-1,-1,-1])
    expect(result['path'].map{|spell| spell.link.id}).to eq [33, 6]
  end

  it "second test" do
    subject.add_spell({
      'id' => 1,
      'ings' => [2, 0, 0, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 2,
      'ings' => [-1, 1, 0, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 3,
      'ings' => [0, -1, 1, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 4,
      'ings' => [0, 0, -1, 1],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 5,
      'ings' => [0, 0, 2, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    bot = CodingGame::Simulation::Bot.new(subject.spells)
    result = bot.find_path([3, 0, -2, -2], [], subject.needed_spells, [0,0,-2,-2])
    expect(result['path'].map{|spell| spell.link.id}).to eq [5, 5, 4, 4]
  end

  it "third test" do
    subject.add_spell({
      'id' => 1,
      'ings' => [2, 0, 0, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 2,
      'ings' => [-1, 1, 0, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 3,
      'ings' => [0, -1, 1, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 4,
      'ings' => [0, 0, -1, 1],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 5,
      'ings' => [0, 0, 2, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 10,
      'ings' => [0, 0, 1, -1],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 11,
      'ings' => [0, -1, -1, 2],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    bot = CodingGame::Simulation::Bot.new(subject.spells)
    result = bot.find_path([3, 0, -2, -2], [], subject.needed_spells, [0,0,-2,-2])
    expect(result['path'].map{|spell| spell.link.id}).to eq [5, 5, 4, 4]
  end

  it "fourth test" do
    subject.add_spell({
      'id' => 1,
      'ings' => [2, 0, 0, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 2,
      'ings' => [-1, 1, 0, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 3,
      'ings' => [0, -1, 1, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 4,
      'ings' => [0, 0, -1, 1],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 5,
      'ings' => [0, -2, 2, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 6,
      'ings' => [1, 1, 1, -1],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 7,
      'ings' => [3, 0, 1, -1],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 8,
      'ings' => [0, -3, 0, 2],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 9,
      'ings' => [-3, 3, 0, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 10,
      'ings' => [1, -3, 1, 1],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    bot = CodingGame::Simulation::Bot.new(subject.spells)
    result = bot.find_path([3, -2, -1, -1], [], subject.needed_spells, [0,-2,-1,-1])
    expect(result['path'].map{|spell| spell.link.id}).to eq [9, 8, 6, 2]
  end
  it "fifth test" do
    subject.add_spell({
      'id' => 1,
      'ings' => [2, 0, 0, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 2,
      'ings' => [-1, 1, 0, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 3,
      'ings' => [0, -1, 1, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 4,
      'ings' => [0, 0, -1, 1],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 5,
      'ings' => [-3, 1, 1, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 6,
      'ings' => [1, 0, 1, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 7,
      'ings' => [2, 2, 0, -1],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 8,
      'ings' => [3, 0, 1, -1],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 9,
      'ings' => [2, -3, 2, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    subject.add_spell({
      'id' => 10,
      'ings' => [-4, 0, 2, 0],
      'castable' => true,
      'repeatable' => false,
      'tome_index' => nil,
      'tax_count' => nil,
      'type' => 'CAST'
    })
    bot = CodingGame::Simulation::Bot.new(subject.spells)
    result = bot.find_path([3, 0, -2, -2], [], subject.needed_spells, [0,0,-2,-2])
    expect(result['path'].map{|spell| spell.link.id}).to eq [6, 10, 4, 6, 4]
  end

  it "6 test" do
    subject.add_spell({
          'id' => 78,
          'ings' => [2, 0, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 79,
          'ings' => [-1, 1, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 80,
          'ings' => [0, -1, 1, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 81,
          'ings' => [0, 0, -1, 1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 10,
          'ings' => [2, 2, 0, -1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 38,
          'ings' => [-2, 2, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 19,
          'ings' => [0, 2, -1, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 32,
          'ings' => [1, 1, 3, -2],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
        'id' => 26,
        'ings' => [1, 1, 1, -1],
        'castable' => true,
        'repeatable' => false,
        'tome_index' => nil,
        'tax_count' => nil,
        'type' => 'LEARN'
    })
    subject.add_spell({
        'id' => 39,
        'ings' => [0, 0, -2, 2],
        'castable' => true,
        'repeatable' => false,
        'tome_index' => nil,
        'tax_count' => nil,
        'type' => 'LEARN'
    })
    bot = CodingGame::Simulation::Bot.new(subject.spells)
    result = bot.find_path([1,0,-3,-2], [], subject.needed_spells, [0,0,-3,-2])
    expect(result['path'].map{|spell| spell.link.id}).to eq [79, 80, 78, 79, 80, 79, 80, 39, 32, 80, 39]
  end

  it "7 test" do
    subject.add_spell({
          'id' => 78,
          'ings' => [2, 0, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 79,
          'ings' => [-1, 1, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 80,
          'ings' => [0, -1, 1, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 81,
          'ings' => [0, 0, -1, 1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 23,
          'ings' => [1, -3, 1, 1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 40,
          'ings' => [0, -2, 2, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 31,
          'ings' => [0, 3, 2, -2],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 36,
          'ings' => [0, -3, 3, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
        'id' => 10,
        'ings' => [2, 2, 0, -1],
        'castable' => true,
        'repeatable' => false,
        'tome_index' => nil,
        'tax_count' => nil,
        'type' => 'LEARN'
    })
    subject.add_spell({
        'id' => 38,
        'ings' => [-2, 2, 0, 0],
        'castable' => true,
        'repeatable' => false,
        'tome_index' => nil,
        'tax_count' => nil,
        'type' => 'LEARN'
    })
    bot = CodingGame::Simulation::Bot.new(subject.spells)
    result = bot.find_path([0,-2,-2,0], [], subject.needed_spells, [-2,-2,0,0])
    expect(result['path'].map{|spell| spell.link.id}).to eq [78, 38, 78, 38, 40]
  end
  it "8 test" do
    subject.add_spell({
          'id' => 78,
          'ings' => [2, 0, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 79,
          'ings' => [-1, 1, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 80,
          'ings' => [0, -1, 1, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 81,
          'ings' => [0, 0, -1, 1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 14,
          'ings' => [0, 0, 0, 1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 4,
          'ings' => [3, 0, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 23,
          'ings' => [1, -3, 1, 1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 13,
          'ings' => [4, 0, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
        'id' => 30,
        'ings' => [-4, 0, 1, 1],
        'castable' => true,
        'repeatable' => false,
        'tome_index' => nil,
        'tax_count' => nil,
        'type' => 'LEARN'
    })
    subject.add_spell({
        'id' => 16,
        'ings' => [1, 0, 1, 0],
        'castable' => true,
        'repeatable' => false,
        'tome_index' => nil,
        'tax_count' => nil,
        'type' => 'LEARN'
    })
    bot = CodingGame::Simulation::Bot.new(subject.spells)
    result = bot.find_path([2,-1,-1,-3], [], subject.needed_spells, [-1,-1,-1,-3])
    expect(result['path'].map{|spell| spell.link.id}).to eq [79, 4, 30, 14, 14]
  end

  it "9 test" do
    subject.add_spell({
          'id' => 78,
          'ings' => [2, 0, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 79,
          'ings' => [-1, 1, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 80,
          'ings' => [0, -1, 1, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    subject.add_spell({
          'id' => 81,
          'ings' => [0, 0, -1, 1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => nil,
          'tax_count' => nil,
          'type' => 'CAST'
      })
    bot = CodingGame::Simulation::Bot.new(subject.spells)
    result = bot.find_path([3,0,-2,-2], [], subject.needed_spells, [-3,-1,-1,-1])
    expect(result['path'].map{|spell| spell.link.id}).to eq [79, 79, 79, 78, 79, 80, 81, 80, 81, 80, 80]
  end
  
  fit "spell tree test" do
    subject.add_spell({'id' => 78,'ings' => [2, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 79,'ings' => [-1, 1, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 80,'ings' => [0, -1, 1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 81,'ings' => [0, 0, -1, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    temporary_id = 82
    all_learns = [[-3, 0, 0, 1],[3, -1, 0, 0],[1, 1, 0, 0],[0, 0, 1, 0],[3, 0, 0, 0],[2, 3, -2, 0]]#,[2, 1, -2, 1],[3, 0, 1, -1],[3, -2, 1, 0],[2, -3, 2, 0],[2, 2, 0, -1],[-4, 0, 2, 0],[2, 1, 0, 0],[4, 0, 0, 0],[0, 0, 0, 1],[0, 2, 0, 0],[1, 0, 1, 0],[-2, 0, 1, 0],[-1, -1, 0, 1],[0, 2, -1, 0],[2, -2, 0, 1],[-3, 1, 1, 0],[0, 2, -2, 1],[1, -3, 1, 1],[0, 3, 0, -1],[0, -3, 0, 2],[1, 1, 1, -1],[1, 2, -1, 0],[4, 1, -1, 0],[-5, 0, 0, 2],[-4, 0, 1, 1],[0, 3, 2, -2],[1, 1, 3, -2],[-5, 0, 3, 0],[-2, 0, -1, 2],[0, 0, -3, 3],[0, -3, 3, 0],[-3, 3, 0, 0],[-2, 2, 0, 0],[0, 0, -2, 2],[0, -2, 2, 0],[0, 0, 2, -1]]
    all_learns.each do |learn_ings|
      subject.add_spell({'id' => temporary_id,'ings' => learn_ings,'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => "LEARN"})
      temporary_id += 1
    end
    tree = CodingGame::Simulation::SpellTree.new
    subject.build_tree(tree.root)

  end
end
