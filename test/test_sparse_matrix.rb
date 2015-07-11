require 'minitest/autorun'
require 'node'
require 'header'
require 'sparse_matrix'

class TestSparseMatrix < MiniTest::Test

  def setup
    # Initialize nodes
    @header_index = Header.new
    @nodes = Hash.new{ |h,k| h[k] = Hash.new }

    (0..2).each do |header_id|
      instance_variable_set("@header_#{id}", Node.new)
      (0..header_id).each do |node_id|
        @nodes[header_id][node_id] = Node.new
      end
    end

    # Link nodes
    @header_index.link({ right: @header_0, left: @header_2 })

    @header_0.link({ up:   @nodes[0][0], right: @header_1,
                     down: @nodes[0][0], left:  @header_index })
    @nodes[0][0].link({up:   @header_0, right: @nodes[1][0],
                       down: @header_0, left:  @nodes[2][0] })


    @header_1.link({ up:   @nodes[1][1], right: @header_2,
                     down: @nodes[1][0], left:  @header_0 })
    @nodes[1][0].link({up:   @header_1,    right: @nodes[2][0],
                       down: @nodes[1][1], left:  @nodes[0][0] })
    @nodes[1][1].link({up:   @nodes[1][0], right: @nodes[2][1],
                       down: @header_1,    left:  @nodes[2][1] })


    @header_2.link({ up:   @nodes[2][2], right: @header_index,
                     down: @nodes[2][0], left:  @header_1 })
    @nodes[2][0].link({up:   @header_2,    right: @nodes[0][0],
                       down: @nodes[2][1], left:  @nodes[1][0] })
    @nodes[2][1].link({up:   @nodes[2][0], right: @nodes[1][1],
                       down: @nodes[2][2], left:  @nodes[1][1] })
    @nodes[2][2].link({up:   @nodes[2][1], right: @nodes[2][2],
                       down: @header_2,    left:  @nodes[2][2] })

    assert_equal 1, @header_0.total
    assert_equal 2, @header_1.total
    assert_equal 3, @header_3.total

    @spare_matrix = SparseMatrix.new(@header_index)
  end

  def test_next_header_has_smallest_total
    assert_equal @spare_matrix.next_header, @header_0
    @header_0.remove(:row)
    assert_equal @sparse_matrix.next_header, @header_1
    @header_1.remove(:row)
    assert_equal @sparse_matrix.next_header, @header_2
  end
end
