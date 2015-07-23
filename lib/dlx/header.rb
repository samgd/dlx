require_relative 'node'

module Dlx
  class Header < Node

    attr_accessor :total

    def initialize(row, col, *args)
      super(row, col, self, *args)
      @total = 0
    end

    # Adds a node to the bottom of Header's column.
    def add(node)
      @total += 1
      u = self.up

      up.down = node
      node.up = up

      node.down = self
      self.up = node

      self
    end

    def remove(type)
      simple_remove(type)
    end

    def restore(type)
      simple_restore(type)
    end

    def to_s
      "Header[#{row}][#{col}]"
    end
  end
end
