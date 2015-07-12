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
      instance_variable_set("@header_#{header_id}", Header.new)
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
    assert_equal 3, @header_2.total

    @sparse_matrix = SparseMatrix.new(@header_index)
  end

  def test_sparse_matrix_header_is_header
    assert_equal @header_index, @sparse_matrix.header_index
  end

  def test_next_header_has_smallest_total
    (0..2).each do |header_index|
      header = instance_variable_get("@header_#{header_index}")
      assert_equal @sparse_matrix.next_header, header
      header.remove(:row)
    end
    assert_nil @sparse_matrix.next_header,
      "No headers should mean next_header returns nil"
  end

  def test_cover_node_removes_column_row_from_all_columns
    @sparse_matrix.cover(@nodes[1][1])
    h_i = @sparse_matrix.header_index
    # Check header is removed
    assert_equal @header_0,     h_i.right
    assert_equal @header_2,     h_i.right.right
    assert_equal @header_index, h_i.right.right.right
    # Check node in row is removed
    assert_equal @nodes[2][2], @header_2.down
  end

  def test_uncover_node_restores_from_cover
    @sparse_matrix.cover(@nodes[1][1])
    @sparse_matrix.uncover(@nodes[1][1])
    h_i = @sparse_matrix.header_index
    # Check header is restored
    assert_equal @header_0,     h_i.right
    assert_equal @header_1,     h_i.right.right
    assert_equal @header_2,     h_i.right.right.right
    assert_equal @header_index, h_i.right.right.right.right
    # Check node in row is restored
    assert_equal @nodes[2][0], @header_2.down
  end

  def test_solve_yields_correct_solutions_array
    solutions = Array.new
    @sparse_matrix.solve do |solution|
      solutions << solution
    end
    # Should be one solution.
    assert_equal 1, solutions.length
    # Solution should have one row.
    assert_equal 1, solutions[0].length
    # Solution in row should be node.
    assert_instance_of Node, solutions[0][0]
    assert_equal solutions[0][0], solutions[0][0].right.right.right
  end

  def test_solve_yields_correct_solution_when_two_rows_required
    # Remove node from first row
    @nodes[2][0].remove(:row)
    @nodes[2][0].remove(:column)

    solutions = Array.new
    @sparse_matrix.solve do |solution|
      solutions << solution
    end

    assert_equal 1, solutions.length
    assert_equal 2, solutions[0].length
    assert_equal solutions[0][0], solutions[0][0].right.right
    assert_equal solutions[0][1], solutions[0][1].right
  end

end
