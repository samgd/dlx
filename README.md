# Ruby Dancing Links

## What is it?

> Dancing links, also known as DLX, is the technique suggested by Donald Knuth to
> efficiently implement his Algorithm X.
> [More](https://en.wikipedia.org/wiki/Dancing_Links)

> "Algorithm X" is the name Donald Knuth used in his paper "Dancing Links" to
> refer to "the most obvious trial-and-error approach" for finding all solutions
> to the exact cover problem.
>
> The exact cover problem is represented in Algorithm X using a matrix A
> consisting of 0s and 1s. The goal is to select a subset of the rows so that
> the digit 1 appears in each column exactly once.
> [More](https://en.wikipedia.org/wiki/Knuth%27s_Algorithm_X)

## Status

It is slow.  I could rewrite it to be faster but it has already been done!

https://github.com/biilmann/Ruby-DLX-Sudoku-Solver

## Usage

```ruby
require 'dlx/sparse_matrix'

matrix = Dlx::SparseMatrix.new

matrix.add("1001001")
      .add("1001000")
      .add("0001101")
      .add("0010110")
      .add("0110011")
matrix << "0100001"

# No guarentee is given on the row order.
matrix.rows
=> ["1001001", "1001000", "0001101", "0010110", "0110011", "0100001"]

matrix.solve
=> [["1001000", "0100001", "0010110"]]

```

## License

See [LICENSE](https://github.com/samgd/dlx/blob/master/LICENSE)
