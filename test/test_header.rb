require 'minitest/autorun'
require 'node'
require 'header'

class TestHeader < MiniTest::Test

  def setup
    # Initialize nodes
    @header = Dlx::Header.new(0, 0)
    @node_1 = Dlx::Node.new(1, 0, @header)
    @node_2 = Dlx::Node.new(2, 0, @header)

    # Link to form a column
    @header.add(@node_1)
           .add(@node_2)
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

  def test_to_s_is_overridden
    assert_equal "Header[0][0]", @header.to_s
  end
end
