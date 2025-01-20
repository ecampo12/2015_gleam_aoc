import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

pub fn look_and_say(input: String) -> String {
  let assert Ok(first) = string.first(input)

  string.to_graphemes(input)
  |> look_and_say_tail(0, first, "")
}

// tail recursively optimized, otherwise it blows up the stack.
fn look_and_say_tail(
  input: List(String),
  count: Int,
  lookat: String,
  acc: String,
) -> String {
  case input {
    [] -> acc <> int.to_string(count) <> lookat
    [head, ..rest] -> {
      case head == lookat {
        True -> {
          look_and_say_tail(rest, count + 1, lookat, acc)
        }
        False -> {
          look_and_say_tail(
            rest,
            1,
            head,
            acc <> int.to_string(count) <> lookat,
          )
        }
      }
    }
  }
}

pub fn part1(input: String) -> #(Int, String) {
  let output =
    list.range(0, 39)
    |> list.fold(input, fn(acc, _x) { look_and_say(acc) })
  #(string.length(output), output)
}

// we pick up where we finished in part 1 in order to not do extra work.
pub fn part2(input: String) -> Int {
  list.range(40, 49)
  |> list.fold(input, fn(acc, _x) { look_and_say(acc) })
  |> string.length
}

pub fn main() {
  let assert Ok(input) = read("input.txt")
  let #(part1_ans, next) = part1(input)
  io.print("Part 1: ")
  io.debug(part1_ans)
  let part2_ans = part2(next)
  io.print("Part 2: ")
  io.debug(part2_ans)
}
