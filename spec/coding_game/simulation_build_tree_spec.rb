require 'coding_game/simulation'

describe "simple" do
  subject {
    CodingGame::Simulation.new
  }

  fit "first test" do
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
          'ings' => [3, 0, 0, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => 0,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 32,
          'ings' => [2, 3, -2, 0],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => 1,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 26,
          'ings' => [0, 2, -2, 1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => 2,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
          'id' => 39,
          'ings' => [-4, 0, 1, 1],
          'castable' => true,
          'repeatable' => false,
          'tome_index' => 3,
          'tax_count' => nil,
          'type' => 'LEARN'
      })
    subject.add_spell({
        'id' => 33,
        'ings' => [2, 1, -2, 1],
        'castable' => true,
        'repeatable' => false,
        'tome_index' => 4,
        'tax_count' => nil,
        'type' => 'LEARN'
    })
    subject.add_spell({
        'id' => 6,
        'ings' => [-2, 0, 1, 0],
        'castable' => true,
        'repeatable' => false,
        'tome_index' => 5,
        'tax_count' => nil,
        'type' => 'LEARN'
    })
    subject.build_tree
    path = subject.get_shortest_path([0,-1,-1,-1], [3,0,0,0])
    # [39, 19, 6, 32, 26, 33]
    subject.remove_learn(39)
    
    expect(true).to eq true
  end
end
