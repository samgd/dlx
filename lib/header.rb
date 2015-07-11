require_relative 'node'

class Header < Node

  def initialize
    @header = self
  end

  def total
    @total ||= calc_total
  end

  private

  def calc_total
    @total = 0
    each_in(:down) { |node| @total += 1 }
    @total
  end
end
