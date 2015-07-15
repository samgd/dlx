module Dlx
  class Node
    attr_accessor :up, :right, :down, :left, :row, :col

    def initialize(row, col, up = self, right = self, down = self, left = self)
      @row = row
      @col = col
      @up     = up
      @right  = right
      @down   = down
      @left   = left
    end

    def header
      @header ||= each_in(:down) { |node| return node if node.instance_of? Header }
    end

    def link(nodes)
      nodes.each_pair { |dir, node| send("#{dir}=", node) }
    end

    def remove(type)
      case type
      when :row
        left.right = right
        right.left = left
      when :column
        up.down = down
        down.up = up
      end
    end

    def restore(type)
      case type
      when :row
        left.right = self
        right.left = self
      when :column
        up.down = self
        down.up = self
      end
    end

    # Traverses doubly linked list in the specified direction.
    # Begins with yieding adjacent node, breaks _before_ yielding self.
    def each_in(direction)
      node = self
      until (node = node.send(direction)) == self do
        yield node
      end
    end

    def to_s
      "Node[#{row}][#{col}]"
    end
  end
end
