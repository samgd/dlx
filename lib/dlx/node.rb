module Dlx
  class Node
    attr_reader :row, :col, :header
    attr_accessor :up, :right, :down, :left

    def initialize(row, col, header, up = self, right = self, down = self, left = self)
      @row, @col = row, col
      @header = header
      @up, @right, @down, @left = up, right, down, left
    end

    def link(nodes)
      nodes.each_pair { |dir, node| send("#{dir}=", node) }
    end

    def remove(type)
      header.total -= 1 if type == :column
      simple_remove(type)
    end

    def restore(type)
      header.total += 1 if type == :column
      simple_restore(type)
    end

    # Traverses doubly linked list in the specified direction.
    # Begins with yieding adjacent node, breaks _before_ yielding self.
    def each_in(direction)
      return enum_for(:each_in, direction) unless block_given?
      node = self
      until (node = node.send(direction)) == self do
        yield node
      end
    end

    def to_s
      "Node[#{row}][#{col}]"
    end

    private

    def simple_remove(type)
      case type
      when :row
        left.right = right
        right.left = left
      when :column
        up.down = down
        down.up = up
      end
    end

    def simple_restore(type)
      case type
      when :row
        left.right = self
        right.left = self
      when :column
        up.down = self
        down.up = self
      end
    end
  end
end
