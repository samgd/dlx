class Node
  attr_accessor :up, :right, :down, :left

  def initialize(up = self, right = self, down = self, left = self)
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
end
