require 'minitest/autorun'
require 'node'

class TestNode < MiniTest::Test

  def setup
    @nodes = Hash.new{ |h,k| h[k] = Hash.new }
    # Create set of nodes
    (0..2).each do |r|
      (0..2).each do |c|
         @nodes[r][c] = Node.new
      end
    end
    # Link nodes to create a toroidal array
    (0..2).each do |r|
      (0..2).each do |c|
        link(@nodes[r][c],
             @nodes[(r-1)%3][c],
             @nodes[r][(c+1)%3],
             @nodes[(r+1)%3][c],
             @nodes[r][(r-1)%3])
      end
    end
  end

  def test_remove_and_restore_node_from_row
    mid_node = @nodes[1][1]
    mid_node.remove(:row)
    assert_equal @nodes[1][0].right, @nodes[1][2]
    assert_equal @nodes[1][2].left,  @nodes[1][0]
    mid_node.restore(:row)
    assert_equal @nodes[1][0].right, mid_node
    assert_equal @nodes[1][2].left,  mid_node
  end

  def test_remove_and_restore_node_from_column
    mid_node = @nodes[1][1]
    mid_node.remove(:column)
    assert_equal @nodes[0][1].down, @nodes[2][1]
    assert_equal @nodes[2][1].up,   @nodes[0][1]
    mid_node.restore(:column)
    assert_equal @nodes[0][1].down, mid_node
    assert_equal @nodes[2][1].up,   mid_node
  end

  def link(node, up, right, down, left)
    node.up    = up
    node.right = right
    node.down  = down
    node.left  = left
  end
end
