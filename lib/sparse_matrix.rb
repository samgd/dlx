require_relative 'header'
require_relative 'node'

class SparseMatrix
  attr_accessor :header_index
  attr_reader :width, :height

  def initialize(header_index)
    @header_index = header_index
    @solution = Array.new   # TODO: This _probably_ shouldn't live here.
    @string_rows = Array.new
    @width = @height = 0
  end

  def <<(string)
    add(string)
  end

  def add(string)
    raise ArgumentError, "Empty string" if string.empty?
    if @width == 0
      @width = string.length
    elsif string.length != @width
      raise ArgumentError, "Width is: #{string.length}, expected: #{@width}"
    end
    @string_rows << string
    @height += 1
  end

  # Yields each solution, if any.
  def solve(&b)
    if next_header.nil?
      b.call(@solution.dup)
    else
      header = next_header
      cover(header)

      header.each_in(:down) do |rowNode|
        @solution.push(rowNode)

        rowNode.each_in(:right) do |rightNode|
          cover(rightNode)
        end

        solve(&b)
        @solution.delete(rowNode)

        rowNode.each_in(:left) do |leftNode|
          uncover(leftNode)
        end
      end
      uncover(header)
    end
  end

  # Returns header with least total.
  def next_header
    min_header = nil
    @header_index.each_in(:right) do |header|
      if !min_header || header.total < min_header.total
        min_header = header
      end
    end
    min_header
  end

  # Removes given node's column from matrix. Removes each node in same row as
  # given node from their columns
  def cover(node)
    node.header.remove(:row)
    node.header.each_in(:down) do |row|
      row.each_in(:right) do |n|
        n.remove(:column)
      end
    end
  end

  # Reverses cover.
  def uncover(node)
    node.header.each_in(:up) do |row|
      row.each_in(:left) do |n|
        n.restore(:column)
      end
    end
    node.header.restore(:row)
  end

  private

  def create_matrix
    @matrix = Hash.new { |h,k| h[k] = Hash.new }
    # Set column headers.
    (0...@width).each { |j| @matrix[0][j] = Header.new }
    @string_rows.each_with_index do |row, i|
      row.each_with_index do |letter, j|
        @matrix[i][j] = Node.new
      end
    end

    # Link header index.
    @header_index.right = @matrix[0][0]
    @header_index.left  = @matrix[0][@width - 1]

    # TODO: Link nodes in matrix
  end

  # Find next node in dir, starting from node.
  def next_in(dir, i, j)
    # TODO: Fill in!
  end
end
