import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/set
import gleam/string.{length, slice, split}
import simplifile.{read}

type Replacement {
  Replacement(from: String, to: String)
}

fn parse(input: String) -> #(String, List(Replacement)) {
  case split(input, "\n\n") {
    [replacements, start] -> {
      let rl =
        split(replacements, "\n")
        |> list.map(fn(line) {
          case split(line, " => ") {
            [from, to] -> Replacement(from, to)
            _ -> Replacement("", "")
          }
        })
      #(start, rl)
    }
    _ -> #("", [])
  }
}

// Unlike String.replace, this function return a list of all replaces of each `from` with `to`
// in the `start` string.
// Example:
// string.replace("ababab", "ab", "c") returns "ccc"
// replace("ababab", "ab", "c") returns ["cabab", "abcab", "ababc"]
fn replace(start: String, from: String, to: String) -> List(String) {
  let len = length(from)
  list.range(0, length(start) - len)
  |> list.fold([], fn(acc, i) {
    let sub = slice(start, i, len)
    case sub == from {
      True -> {
        let new_start =
          slice(start, 0, i) <> to <> slice(start, i + len, length(start))
        list.append(acc, [new_start])
      }
      False -> acc
    }
  })
}

pub fn part1(input: String) -> Int {
  let #(start, replacements) = parse(input)
  list.fold(replacements, set.new(), fn(acc, x) {
    replace(start, x.from, x.to)
    |> list.fold(acc, fn(bcc, y) { set.insert(bcc, y) })
  })
  |> set.size
}

// Not really needed, but it clearly shows the intent of the function. A for loop that can break.
fn for_loop_break(
  range: List(Int),
  acc: a,
  func: fn(a, Int) -> list.ContinueOrStop(a),
) -> a {
  list.fold_until(range, acc, func)
}

// Looks like a lot, but it's just finding a substring that can be replaced, replacing it, and
// repeating until the string is the letter "e". I'm sure there's a recursive way to do this, but
// I've spent enough time on this problem.
fn synthesize(start: String, replacements: Dict(String, String)) -> Int {
  let final =
    // 10 is arbitrary, but it works for the input
    for_loop_break(list.range(0, 10), #(start, 0), fn(acc, _x) {
      case start == "e" {
        True -> {
          list.Stop(acc)
        }
        False -> {
          let len = length(start)
          for_loop_break(list.range(0, len - 1), acc, fn(bcc, i) {
            for_loop_break(list.range(1, len), bcc, fn(ccc, j) {
              let #(start, steps) = ccc
              let sub = slice(start, i, j)
              case dict.get(replacements, sub) {
                Ok(to) -> {
                  let new_start =
                    slice(start, 0, i) <> to <> slice(start, j + i, len)
                  list.Stop(#(new_start, steps + 1))
                }
                _ -> {
                  list.Continue(ccc)
                }
              }
            })
            |> list.Continue
          })
          |> list.Continue
        }
      }
    })

  let #(_, steps) = final
  steps
}

pub fn part2(input: String) -> Int {
  let #(start, replacements) = parse(input)
  let r =
    list.map(replacements, fn(x) { #(x.to, x.from) })
    |> dict.from_list
  synthesize(start, r)
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
