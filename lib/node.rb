class Node
  attr_accessor :up, :right, :down, :left

  def initialize(up = self, right = self, down = self, left = self)
    @up    = up
    @right = right
    @down  = down
    @left  = left
  end

  def link(nodes)
    nodes.each_pair { |dir, node| instance_variable_set("@#{dir}", node) }
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
    case direction
    when :up
      until (node = node.up) == self do
        yield node
      end
    when :right
      until (node = node.right) == self do
        yield node
      end
    when :down
      until (node = node.down) == self do
        yield node
      end
    when :left
      until (node = node.left) == self do
        yield node
      end
    end
  end
end
