import gleam/io
import gleam/list
import gleam/set
import gleam/string
import simplifile.{read}

fn travel(directions: List(String), pos: #(Int, Int)) -> List(#(Int, Int)) {
  case directions {
    [x, ..rest] ->
      case x {
        "^" -> {
          let next = #(pos.0, pos.1 + 1)
          [next, ..travel(rest, next)]
        }
        "v" -> {
          let next = #(pos.0, pos.1 - 1)
          [next, ..travel(rest, next)]
        }
        "<" -> {
          let next = #(pos.0 - 1, pos.1)
          [next, ..travel(rest, next)]
        }
        ">" -> {
          let next = #(pos.0 + 1, pos.1)
          [next, ..travel(rest, next)]
        }
        _ -> [pos]
      }
    [] -> [#(0, 0)]
  }
}

pub fn part1(input: String) -> Int {
  string.to_graphemes(input)
  |> travel(#(0, 0))
  |> set.from_list
  |> set.size
}

pub fn part2(input: String) -> Int {
  let #(santa, robosanta) =
    string.to_graphemes(input)
    |> list.index_map(fn(x, i) { #(x, i) })
    |> list.partition(fn(x) { x.1 % 2 == 0 })

  let to_set = fn(s: List(#(String, Int))) {
    list.map(s, fn(x) { x.0 })
    |> travel(#(0, 0))
    |> set.from_list
  }

  let a = to_set(santa)
  let b = to_set(robosanta)

  set.union(a, b) |> set.size
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
