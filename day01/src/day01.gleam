import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

pub fn part1(floors: String) -> Int {
  string.to_graphemes(floors)
  |> list.fold(0, fn(acc, x) {
    case x == "(" {
      True -> acc + 1
      False -> acc - 1
    }
  })
}

fn find_neg(f: List(String), floor: Int, count: Int) -> Int {
  case floor {
    _ if floor < 0 -> count - 1
    _ ->
      case f {
        [x, ..rest] ->
          case x == "(" {
            True -> find_neg(rest, floor + 1, count + 1)
            False -> find_neg(rest, floor - 1, count + 1)
          }
        _ -> count
      }
  }
}

pub fn part2(floors: String) -> Int {
  string.to_graphemes(floors) |> find_neg(0, 1)
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
