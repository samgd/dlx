require_relative 'node'

class Header < Node

  def total
    @total ||= calc_total
  end

  private

  def calc_total
    node = self
    @total = 0
    until (node = node.down) == self do
      @total += 1
    end
    @total
  end
end
