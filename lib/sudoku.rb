require_relative 'dlx/sparse_matrix'

# Cell constraints - one unique number in each cell

def cell_constraints
  (0...9).each do |row|
    (0...9).each do |col|
      (0...9).each do |n|
        string = ("0"*((row * 9) + col)) + "1"
        string << "0" * (81 - string.length)
        yield string
        #puts "R#{row}C#{col}##{n}  #{string}"
      end
    end
  end
end

# Row constraints - unique number in each row

def row_constraints
  (0...9).each do |row|
    (0...9).each do |col|
      (0...9).each do |n|
        string = "0"*row*9 + "0"*n + "1"
        string << "0" * (81 - string.length)
        yield string
        #puts "R#{row}C#{col}##{n}  #{string}"
      end
    end
  end
end

# Column constraints - unique number in each column

def column_constraints
  (0...9).each do |row|
    (0...9).each do |col|
      (0...9).each do |n|
        string = "0"*col*9 + "0"*n + "1"
        string << "0" * (81 - string.length)
        yield string
        #puts "R#{row}C#{col}##{n}  #{string}"
      end
    end
  end
end

# Block constraints - unique number in each block

def block_constraints
  (0...9).each do |row|
    (0...9).each do |col|
      (0...9).each do |n|
        block = (col / 3) + (3 * (row / 3))
        string = "0"*9*block + "0"*n + "1"
        string << "0" * (81 - string.length)
        yield string
        #puts "R#{row}C#{col}##{n}  #{string}"
      end
    end
  end
end

def constraints(sudoku)
  strings = []
  (0...9).each do |row|
    (0...9).each do |col|
      (0...9).each do |n|

        # cell constraint
        string = ("0"*((row * 9) + col)) + "1"
        string << "0" * (81 - string.length)

        # row constraint
        string << "0"*row*9 + "0"*n + "1"
        string << "0" * (162 - string.length)
        #string << a_string

        # column constraint
        string << "0"*col*9 + "0"*n + "1"
        string << "0" * (243 - string.length)
        #string << b_string

        # block constraint
        block = (col / 3) + (3 * (row / 3))
        string << "0"*9*block + "0"*n + "1"
        string << "0" * (324 - string.length)
        #string << c_string

        strings << string if sudoku[row][col] == (n + 1)

        # Row skip - row already contains n
        next if sudoku[row].include? (n + 1)

        # Column skip - column already contains n
        c = sudoku.inject([]) { |acc, row| acc << row[col] }
        next if c.include? (n + 1)

        # Block skip
        next if get_block(block, sudoku).include? (n + 1)

        strings << string
      end
    end
  end
  strings
end

def get_block(block, sudoku)
  block_row = block / 3
  block_col = block % 3

  b = []
  (0..2).each do |row|
    (0..2).each do |col|
      i = (3 * block_row) + row
      j = (3 * block_col) + col
      b << sudoku[i][j]
    end
  end
  b
end

def solve(string)
  sudoku = string.scan(/.{9}/)
  sudoku = sudoku.map{ |row| row.scan(/./).map{ |x| x.to_i } }
  #p sudoku
  #col = sudoku.inject([]) { |acc, row| acc << row[0] }

  matrix = Dlx::SparseMatrix.new

  constraints(sudoku).each { |constraint| matrix.add(constraint) }

  #puts "added #{matrix.height}"

  i = 0
  matrix.solve
  #puts "done"
  matrix.solve do |solution|
    puts "sol, #{(i += 1)}"
  end
end
#solve("2564891733746159829817234565932748617128.6549468591327635147298127958634849362715")
#solve("3.542.81.4879.15.6.29.5637485.793.416132.8957.74.6528.2413.9.655.867.192.965124.8")
#solve("..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4..")
#solve(".....5.8....6.1.43..........1.5........1.6...3.......553.....61........4.........")
#solve("....7..2.8.......6.1.2.5...9.54....8.........3....85.1...3.2.8.4.......9.7..6....")
solve(".8...4.5....7..3............1..85...6.....2......4....3.26............417........")
#solve("...........5....9...4....1.2....3.5....7.....438...2......9.....1.4...6..........")
#solve("000000010400000000020000000000050407008000300001090000300400200050100000000806000")
#solve("140805000006000070000000300000200010300070000500000000800000002010400000000000500")
#solve("000700205890400000000000600052060000000300070000000000300000010000020700400000000")
