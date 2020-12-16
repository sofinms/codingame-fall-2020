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
    tree = CodingGame::Simulation::SpellTree.new subject.spells
    tree.build_tree(tree.root)
    path = subject.get_shortest_brew_path(tree, [0,-1,-1,-1], [3,0,0,0])
    expect(path).to eq [78, 33, 6]
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
    tree = CodingGame::Simulation::SpellTree.new subject.spells
    tree.build_tree(tree.root)
    path = subject.get_shortest_brew_path(tree, [0,0,-2,-2], [3,0,0,0])
    expect([[5, 4, 4, 5], [5, 4, 5, 4]].include? path).to eq true
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
    tree = CodingGame::Simulation::SpellTree.new subject.spells
    tree.build_tree(tree.root)
    path = subject.get_shortest_brew_path(tree, [0,0,-2,-2], [3,0,0,0])
    expect([[5, 4, 4, 5], [5, 4, 5, 4]].include? path).to eq true
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
    tree = CodingGame::Simulation::SpellTree.new subject.spells
    tree.build_tree(tree.root)
    path = subject.get_shortest_brew_path(tree, [0,-2,-1,-1], [3,0,0,0])
    expect(path).to eq [9, 8, 6, 2]
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
    tree = CodingGame::Simulation::SpellTree.new subject.spells
    tree.build_tree(tree.root)
    path = subject.get_shortest_brew_path(tree, [0,0,-2,-2], [3,0,0,0])
    expect([[6, 10, 4, 6, 4], [6, 4, 6, 4, 10]].include? path).to eq true
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
    tree = CodingGame::Simulation::SpellTree.new subject.spells
    tree.build_tree(tree.root)
    path = subject.get_shortest_brew_path(tree, [0,0,-3,-2], [3,0,0,0])
    expect(path).to eq [38, 80, 80, 39, 32, 80, 39, 32, 39]
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
    tree = CodingGame::Simulation::SpellTree.new subject.spells
    tree.build_tree(tree.root)
    path = subject.get_shortest_brew_path(tree, [-2,-2,0,0], [3,0,0,0])
    expect(path).to eq [38, 78]
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
    tree = CodingGame::Simulation::SpellTree.new subject.spells
    tree.build_tree(tree.root)
    path = subject.get_shortest_brew_path(tree, [-1,-1,-1,-3], [3,0,0,0])
    expect([[79, 4, 30, 14, 14], [79, 14, 13, 30, 14]].include? path).to eq true
  end
end
