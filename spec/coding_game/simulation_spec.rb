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
    result = bot.find_path([4,-1,-1,-1], [], subject.needed_spells)
    expect(result['path'].map{|spell| spell.id}).to eq [78, 33, 6]
  end
end
