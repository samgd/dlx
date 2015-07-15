require 'minitest/autorun'
require 'node'
require 'header'

class TestHeader < MiniTest::Test

  def setup
    # Initialize nodes
    @header = Header.new(0, 0)
    @node_1 = Node.new(1, 0)
    @node_2 = Node.new(2, 0)

    # Link to form a column
    @header.link({ down: @node_1, up: @node_2 })
    @node_1.link({ down: @node_2, up: @header })
    @node_2.link({ down: @header, up: @node_1 })
  end

  def test_header_total_equals_sum_of_nodes_in_column
    assert_equal 2, @header.total
  end

  def test_nodes_return_correct_header
    assert_equal @header, @node_1.header
    assert_equal @header, @node_2.header
  end

  def test_header_returns_header_as_self
    assert_equal @header, @header.header
  end
end
