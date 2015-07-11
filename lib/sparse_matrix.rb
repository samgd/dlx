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
end
