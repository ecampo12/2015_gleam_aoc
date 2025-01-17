import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

fn parse(input: String) -> List(#(Int, Int, Int)) {
  string.split(input, "\n")
  |> list.map(fn(x) {
    case string.split(x, "x") {
      [x, y, z] -> {
        let assert Ok(a) = int.parse(x)
        let assert Ok(b) = int.parse(y)
        let assert Ok(c) = int.parse(z)
        #(a, b, c)
      }
      _ -> #(-1, -1, -1)
    }
  })
}

pub fn part1(input: String) -> Int {
  parse(input)
  |> list.fold(0, fn(acc, x) {
    let #(l, w, h) = x
    let min = case list.sort([l * w, w * h, h * l], int.compare) {
      [x, ..] -> x
      _ -> -1
    }
    min + acc + 2 * l * w + 2 * w * h + 2 * h * l
  })
}

pub fn part2(input: String) -> Int {
  parse(input)
  |> list.fold(0, fn(acc, x) {
    let #(l, w, h) = x
    let ribbon = case list.sort([l, w, h], int.compare) {
      [x, y, ..] -> 2 * x + 2 * y
      _ -> -1
    }
    acc + ribbon + l * w * h
  })
}

pub fn main() {
  let assert Ok(input) = read("input.txt")
  let part1_ans = part1(input)
  io.print("Part 1: ")
  io.debug(part1_ans)
  let part2_ans = part2(input)
  io.print("Part 2: ")
  io.debug(part2_ans)
}
