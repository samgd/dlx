require_relative 'header'
require_relative 'node'

class SparseMatrix
  attr_accessor :header_index

  def initialize(header_index)
    @header_index = header_index
  end

  # Returns header with least total.
  def next_header
    min_header = nil
    header_index.each_in(:right) do |header|
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
      row.each_in(:right) do |node|
        node.remove(:column)
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
end
