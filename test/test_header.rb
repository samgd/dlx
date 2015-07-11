require 'minitest/autorun'
require 'node'
require 'header'

class TestHeader < MiniTest::Test

  def setup
    # Initialize nodes
    @header = Header.new
    @node_1 = Node.new
    @node_2 = Node.new

    # Link to form a column
    @header.link({ down: @node_1, up: @node_2 })
    @node_1.link({ down: @node_2, up: @header })
    @node_2.link({ down: @header, up: @node_1 })
  end

  def test_header_total_equals_sum_of_nodes_in_column
    assert_equal 2, @header.total
  end
end
