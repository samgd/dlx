require 'minitest/autorun'
require 'node'
require 'header'
require 'sparse_matrix'

class TestSparseMatrix < MiniTest::Test

  def setup
    @sparse_matrix = SparseMatrix.new
    @sparse_matrix.add("111")
                  .add("011")
                  .add("001")
    @nodes = @sparse_matrix.create_matrix
  end

  def test_sparse_matrix_dimensions_are_correct
    assert_equal 3, @sparse_matrix.height
    assert_equal 3, @sparse_matrix.width
  end

  def test_sparse_matrix_header_is_initialized
    assert_equal 0,  @sparse_matrix.header_index.row
    assert_equal -1, @sparse_matrix.header_index.col
  end

  def test_next_header_has_smallest_total
    header_totals = Array.new
    (0...@sparse_matrix.width).each do |n|
      header = @sparse_matrix.next_header
      header_totals << header.total
      header.remove(:row)
    end
    assert_equal header_totals.sort, header_totals
  end

  def test_covering_node_removes_header_and_removes_nodes_in_row_from_their_cols
    h_i = @sparse_matrix.header_index
    @sparse_matrix.cover(@nodes[2][1])
    # Check header is removed
    assert_equal @nodes[0][0], h_i.right
    assert_equal @nodes[0][2], h_i.right.right
    assert_equal h_i,          h_i.right.right.right
    # Check node in row is removed
    assert_equal @nodes[3][2], @nodes[0][2].down
  end

  def test_uncover_reverts_cover
    h_i = @sparse_matrix.header_index
    @sparse_matrix.cover(@nodes[1][1])
    @sparse_matrix.uncover(@nodes[1][1])
    # Check header is restored
    assert_equal @nodes[0][0],  h_i.right
    assert_equal @nodes[0][1],  h_i.right.right
    assert_equal @nodes[0][2],  h_i.right.right.right
    assert_equal h_i,           h_i.right.right.right.right
    # Check node in row is restored
    assert_equal @nodes[1][2], @nodes[0][2].down
  end

  def test_solve_yields_correct_solutions
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

  def test_solve_yields_correct_solutions_array
    solutions = @sparse_matrix.solve
    # Should be one solution.
    assert_equal 1, solutions.length
    # Solution should have one row.
    assert_equal 1, solutions[0].length
    # Solution in row should be node.
    assert_instance_of Node, solutions[0][0]
    assert_equal solutions[0][0], solutions[0][0].right.right.right
  end

  def test_solve_yields_correct_solution_when_two_rows_required
    new_matrix = SparseMatrix.new
    new_matrix.add("110")
              .add("010")
              .add("001")
    new_matrix.create_matrix

    solutions = Array.new
    new_matrix.solve do |solution|
      solutions << solution
    end

    assert_equal 1, solutions.length
    assert_equal 2, solutions[0].length
    # Check first solution row.
    assert_equal solutions[0][0], solutions[0][0].right.right
    # Check second solution row.
    assert_equal solutions[0][1], solutions[0][1].right
  end

  def test_adding_invalid_row_raises_exception
    new_matrix = SparseMatrix.new
    assert_equal 0, new_matrix.width
    assert_equal 0, new_matrix.height

    assert_raises(ArgumentError) { new_matrix << "" }

    new_matrix << "0" * 10
    assert_equal 10, new_matrix.width
    assert_equal 1,  new_matrix.height

    assert_raises(ArgumentError) { new_matrix << "1" * 9 }
    assert_raises(ArgumentError) { new_matrix << "1" * 11 }
  end

  def test_create_matrix_nodes_linked
    matrix = SparseMatrix.new
    header = matrix.header_index
    matrix.add("11")
          .add("10")
    m = matrix.create_matrix

    assert_equal m[0][0], header.right
    assert_equal m[0][1], header.right.right
    assert_equal header,  header.right.right.right

    assert_equal header, header.right.down.down.right.up.up.left
  end
end
