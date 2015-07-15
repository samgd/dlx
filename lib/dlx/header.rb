require_relative 'node'

module Dlx
  class Header < Node

    def initialize(*args)
      super(*args)
      @header = self
    end

    def total
      @total ||= calc_total
    end

    def to_s
      "Header[#{row}][#{col}]"
    end

    private

    def calc_total
      @total = 0
      each_in(:down) { |node| @total += 1 }
      @total
    end
  end
end
