require_relative 'header'
require_relative 'node'

module Dlx
  class SparseMatrix
    attr_reader :root, :width, :height, :headers

    def initialize
      @root = Dlx::Header.new(0, -1)
      @string_rows = Array.new
      @width = @height = 0
      @headers = Array.new
    end

    def <<(string)
      add(string)
    end

    def add(string)
      raise ArgumentError, "Empty string" if string.empty?
      if @width == 0
        @width = string.length
        create_headers
      elsif string.length != @width
        raise ArgumentError, "Width is: #{string.length}, expected: #{@width}"
      end

      row = []
      string.scan(/./).zip(@headers).each do |l, header|
        if l == "1"
          node = Dlx::Node.new(@height, header.col, header)
          row << node
          header.add(node)
        end
      end

      link_row(row)

      @string_rows << string
      @height += 1
      self
    end

    def create_headers
      @width.times do |col|
        @headers << Dlx::Header.new(0, col)
      end
      link_row(@headers)
      @root.right = @headers.first
      @root.right.left = @root
      @root.left = @headers.last
      @root.left.right = @root
    end

    def link_row(row)
      row_length = row.length
      row.each_with_index do |node, i|
        node.link({ right: row[(i+1) % row_length],
                    left:  row[(i-1) % row_length]})
      end
    end

    def rows
      @string_rows
    end

    def solve(&block)
      if block
        search(0, [], &block)
      else
        solutions = Array.new
        search(0, []) { |solution| solutions << solution }
        solutions
      end
    end

    # Returns header with least total.
    def next_header
      min_header = nil
      @root.each_in(:right) do |header|
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
        row.each_in(:right) { |n| n.remove(:column) }
      end
    end

    # Reverses cover.
    def uncover(node)
      node.header.each_in(:up) do |row|
        row.each_in(:left) { |n| n.restore(:column) }
      end
      node.header.restore(:row)
    end

    private

    def search(n, solution, &b)
      if next_header.nil?
        b.call(solution.dup)
      else
        header = next_header
        cover(header)

        header.each_in(:down) do |rowNode|
          solution.push(@string_rows[rowNode.row])

          rowNode.each_in(:right) { |rightNode| cover(rightNode) }

          search(n + 1, solution, &b)
          solution.pop

          rowNode.each_in(:left) { |leftNode| uncover(leftNode) }
        end
        uncover(header)
      end
    end
  end
end
