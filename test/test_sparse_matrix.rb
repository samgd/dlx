require 'minitest/autorun'
require'node'
require'header'
require'sparse_matrix'

class TestSparseMatrix < MiniTest::Test

  def setup
    @sparse_matrix = Dlx::SparseMatrix.new
    @sparse_matrix.add("111")
                  .add("011")
                  .add("001")
    @headers = @sparse_matrix.headers
    @root = @sparse_matrix.root
  end

  def test_sparse_matrix_dimensions_are_correct
    assert_equal 3, @sparse_matrix.height
    assert_equal 3, @sparse_matrix.width
  end

  def test_sparse_matrix_header_is_initialized
    assert_equal 0,  @sparse_matrix.root.row
    assert_equal (-1), @sparse_matrix.root.col
  end

  def test_sparse_matrix_rows_are_correct
    assert_equal ["111", "011", "001"].sort,
                 @sparse_matrix.rows.sort
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

  def test_header_positions_are_correct
    assert_equal 0, @headers[0].col
    assert_equal 0, @headers[0].row

    assert_equal 1, @headers[1].col
    assert_equal 0, @headers[1].row

    assert_equal 2, @headers[2].col
    assert_equal 0, @headers[2].row

    assert_equal @root, @headers[0].left
    assert_equal @root, @headers[2].right
  end

  def test_header_totals_are_correct
    assert_equal 1, @headers[0].total
    assert_equal 2, @headers[1].total
    assert_equal 3, @headers[2].total
  end

  def test_covering_node_removes_header_and_removes_nodes_in_row_from_their_cols
    @sparse_matrix.cover(@headers[1].down)

    assert_equal @headers[2], @headers[0].right
    assert_equal @root,       @headers[2].right
    assert_equal @headers[0], @root.right

    assert_equal @headers[0], @headers[0].down
    assert_equal @headers[2], @headers[2].down.down

    assert_equal 0, @headers[0].total
    assert_equal 1, @headers[2].total
  end

  def test_uncover_reverts_cover
    node = @root.right.right.down

    @sparse_matrix.cover(node)
    @sparse_matrix.uncover(node)

    assert_equal 3,           @headers[2].total
    assert_equal @headers[1], @headers[0].right
    assert_equal @headers[2], @headers[1].right
    assert_equal @root,       @headers[2].right

    assert_equal @headers[0], @headers[0].down.down
    assert_equal @headers[0], @headers[0].down.up
    assert_equal @headers[2], @headers[2].down.down.down.down
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

    assert_equal "111", solutions[0][0]
  end

  def test_solve_returns_correct_solutions_array
    solutions = @sparse_matrix.solve
    # Should be one solution.
    assert_equal 1, solutions.length
    # Solution should have one row.
    assert_equal 1, solutions[0].length
    # Solution in row should be node.
    assert_equal "111", solutions[0][0]
  end

  def test_solve_returns_correct_solution_when_two_rows_required
    new_matrix = Dlx::SparseMatrix.new
    new_matrix.add("110")
              .add("010")
              .add("001")

    solutions = new_matrix.solve

    assert_equal 1, solutions.length
    assert_equal 2, solutions[0].length
    assert_equal ["110", "001"].sort, solutions[0].sort
  end

  def test_adding_invalid_row_raises_exception
    assert_raises(ArgumentError) { @sparse_matrix << "" }

    old_height = @sparse_matrix.height
    width = @sparse_matrix.width

    @sparse_matrix << "0" * width
    assert_equal old_height + 1,  @sparse_matrix.height

    assert_raises(ArgumentError) { @sparse_matrix << "1" * (width - 1) }
    assert_raises(ArgumentError) { @sparse_matrix << "1" * (width + 1) }
  end

  def test_create_matrix_nodes_are_correctly_linked
    matrix = Dlx::SparseMatrix.new
    header = matrix.root
    matrix.add("11")
          .add("10")

    assert_equal header,  header.right.right.right

    assert_equal header, header.right.down.down.right.up.up.left
  end

  def test_solve_returns_correct_solution_for_larger_matrix
    matrix = Dlx::SparseMatrix.new
    matrix.add("0010110")
          .add("1001001")
          .add("0110010")
          .add("1001000")
          .add("0100001")
          .add("0001101")
    assert_equal ["0010110", "1001000", "0100001"].sort,
                 matrix.solve[0].sort
  end
end
