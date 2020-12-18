require 'coding_game/simulation'
require "tree_support"

describe "simple" do
  subject {
    CodingGame::Simulation.new
  }

  it "first test" do
    subject.add_spell({'id' => 78,'ings' => [2, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 79,'ings' => [-1, 1, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 80,'ings' => [0, -1, 1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 81,'ings' => [0, 0, -1, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 19,'ings' => [0, 2, -1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 32,'ings' => [1, 1, 3, -2],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 26,'ings' => [1, 1, 1, -1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 39,'ings' => [0, 0, -2, 2],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 33,'ings' => [-5, 0, 3, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 6,'ings' => [2, 1, -2, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    current_ings = [3,0,0,0]
    subject.build_tree current_ings
    if ENV['DEBUG'] == '1'
      puts TreeSupport.tree(subject.tree.root)
    end
    path = subject.get_shortest_path([0,-1,-1,-1], current_ings)
    expect(path.map{|x| x.id}).to eq [78, 33, 6]
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
    current_ings = [3,0,0,0]
    subject.build_tree current_ings
    if ENV['DEBUG'] == '1'
      puts TreeSupport.tree(subject.tree.root)
    end
    path = subject.get_shortest_path([0,0,-2,-2], current_ings)
    expect([[5, 4, 4, 5], [5, 4, 5, 4]].include? path.map{|x| x.id}).to eq true
  end

  fit "third test" do
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
    current_ings = [3,0,0,0]
    subject.build_tree current_ings
    if ENV['DEBUG'] == '1'
      puts TreeSupport.tree(subject.tree.root)
    end
    path = subject.get_shortest_path([0,0,-2,-2], current_ings)
    p path.map{|x| x.id}
    expect([[2, 5, 11, 5]].include? path.map{|x| x.id}).to eq true
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
    current_ings = [3,0,0,0]
    subject.build_tree current_ings
    if ENV['DEBUG'] == '1'
      puts TreeSupport.tree(subject.tree.root)
    end
    path = subject.get_shortest_path([0,-2,-1,-1], current_ings)
    path_spell_ids = path.map{|x| x.id}
    expect([[9, 8, 6, 2], [9, 8, 7, 9], [9, 10, 1, 9]].include? path_spell_ids).to eq true
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
    current_ings = [3,0,0,0]
    subject.build_tree current_ings
    if ENV['DEBUG'] == '1'
      puts TreeSupport.tree(subject.tree.root)
    end
    path = subject.get_shortest_path([0,0,-2,-2], current_ings)
    expect([[6, 10, 4, 6, 4], [6, 4, 6, 4, 10]].include? path.map{|x| x.id}).to eq true
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
    current_ings = [3,0,0,0]
    subject.build_tree current_ings
    if ENV['DEBUG'] == '1'
      puts TreeSupport.tree(subject.tree.root)
    end
    path = subject.get_shortest_path([0,0,-3,-2], current_ings)
    expect([[38, 80, 80, 39, 32, 80, 39, 32, 39], [38, 80, 80, 39, 32, 80, 38, 80, 39]].include? path.map{|x| x.id}).to eq true
  end

  it "7 test" do
    subject.add_spell({'id' => 78,'ings' => [2, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 79,'ings' => [-1, 1, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 80,'ings' => [0, -1, 1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 81,'ings' => [0, 0, -1, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 23,'ings' => [1, -3, 1, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 40,'ings' => [0, -2, 2, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 31,'ings' => [0, 3, 2, -2],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 36,'ings' => [0, -3, 3, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 10,'ings' => [2, 2, 0, -1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 38,'ings' => [-2, 2, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    current_ings = [3,0,0,0]
    subject.build_tree current_ings
    if ENV['DEBUG'] == '1'
      puts TreeSupport.tree(subject.tree.root)
    end
    path = subject.get_shortest_path([-2,-2,0,0], current_ings)
    expect([[38, 78], [78, 38]].include? path.map{|x| x.id}).to eq true
  end
  it "8 test" do
    subject.add_spell({'id' => 78,'ings' => [2, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 79,'ings' => [-1, 1, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 80,'ings' => [0, -1, 1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 81,'ings' => [0, 0, -1, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 14,'ings' => [0, 0, 0, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 4,'ings' => [3, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 23,'ings' => [1, -3, 1, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 13,'ings' => [4, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 30,'ings' => [-4, 0, 1, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 16,'ings' => [1, 0, 1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    current_ings = [3,0,0,0]
    subject.build_tree current_ings
    if ENV['DEBUG'] == '1'
      puts TreeSupport.tree(subject.tree.root)
    end
    path = subject.get_shortest_path([-1,-1,-1,-3], current_ings)
    expect([[79, 4, 30, 14, 14], [79, 14, 13, 30, 14], [14, 4, 30, 79, 14], [79, 14, 13, 14, 30]].include? path.map{|x| x.id}).to eq true
  end

  it "9 test" do
    subject.add_spell({'id' => 78,'ings' => [2, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 79,'ings' => [-1, 1, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 80,'ings' => [0, -1, 1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 81,'ings' => [0, 0, -1, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 36,'ings' => [0, -3, 3, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 4,'ings' => [3, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 9,'ings' => [2, -3, 2, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 3,'ings' => [0, 0, 1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 14,'ings' => [0, 0, 0, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 13,'ings' => [3, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    current_ings = [5,0,0,0]
    subject.build_tree current_ings
    if ENV['DEBUG'] == '1'
      puts TreeSupport.tree(subject.tree.root)
    end
    path = subject.get_shortest_path([-2,0,-2,0], current_ings)
  end

  it "10 test" do
    subject.add_spell({'id' => 78,'ings' => [2, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 79,'ings' => [-1, 1, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 80,'ings' => [0, -1, 1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 81,'ings' => [0, 0, -1, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 86,'ings' => [-3, 1, 1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 88,'ings' => [2, 2, 0, -1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 90,'ings' => [2, -2, 0, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    current_ings = [4,0,0,0]
    subject.build_tree current_ings
    if ENV['DEBUG'] == '1'
      puts TreeSupport.tree(subject.tree.root)
    end
    path = subject.get_shortest_path([-1,-1,-1,-3], current_ings)
    # p path.map{|x| x.id}
    path = subject.get_shortest_path([-2,0,0,-3], current_ings)
    # p path.map{|x| x.id}
    path = subject.get_shortest_path([0,-3,0,-2], current_ings)
    # p path.map{|x| x.id}
    path = subject.get_shortest_path([0,0,-2,-3], current_ings)
    # p path.map{|x| x.id}
    path = subject.get_shortest_path([0,0,-2,-2], current_ings)
    # p path.map{|x| x.id}
  end
  it "11 test" do
    subject.add_spell({'id' => 78,'ings' => [2, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 79,'ings' => [-1, 1, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 80,'ings' => [0, -1, 1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 81,'ings' => [0, 0, -1, 1],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'CAST'})
    subject.add_spell({'id' => 87,'ings' => [3, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 89,'ings' => [-5, 0, 3, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 90,'ings' => [-4, 0, 2, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 93,'ings' => [4, 1, -1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 94,'ings' => [0, 2, -1, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    subject.add_spell({'id' => 95,'ings' => [4, 0, 0, 0],'castable' => true,'repeatable' => false,'tome_index' => nil,'tax_count' => nil,'type' => 'LEARN'})
    
    current_ings = [3,0,0,0]
    subject.build_tree current_ings
    if ENV['DEBUG'] == '1'
      puts TreeSupport.tree(subject.tree.root)
    end
    path = subject.get_shortest_path([-1,-3,-1,-1], current_ings)
    path = subject.get_shortest_path([0,-2,-2,0], current_ings)
    path = subject.get_shortest_path([0,0,-2,-2], current_ings)
    path = subject.get_shortest_path([-2,0,-3,0], current_ings)
    path = subject.get_shortest_path([-2,-2,0,0], current_ings)
  end
end
