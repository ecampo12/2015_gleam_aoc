import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import simplifile.{read}

fn parse(input: String) -> #(Int, Int) {
  let assert Ok(re) = regexp.from_string("\\d+")
  let nums =
    regexp.scan(re, input)
    |> list.map(fn(x) {
      let assert Ok(n) = x.content |> int.parse
      n
    })
  case nums {
    [row, col] -> #(row, col)
    _ -> #(0, 0)
  }
}

// finds the code placement given it's coordinates.
pub fn get_triangle_code(coord: #(Int, Int)) -> Int {
  let #(row, col) = coord
  let triangle = { { row + col - 1 } * { row + col } } / 2
  triangle - row + 1
}

pub fn part1(input: String) -> Int {
  let code = parse(input) |> get_triangle_code
  list.range(1, code - 1)
  |> list.fold(20_151_125, fn(acc, _x) { { acc * 252_533 } % 33_554_393 })
}

pub fn main() {
  let assert Ok(input) = read("input.txt")
  let part1_ans = part1(input)
  io.print("Part 1: ")
  io.debug(part1_ans)
}
