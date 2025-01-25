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

fn sythize_start(start: String, replacements: Dict(String, String)) -> Int {
  let steps =
    list.range(0, 9)
    // 9 is arbitrary, but it works for the input
    |> list.fold_until(#(start, 0), fn(xcc, _x) {
      case string.contains(start, "e") {
        True -> {
          list.Stop(xcc)
        }
        False -> {
          let len = length(start)
          list.range(0, len - 1)
          |> list.fold_until(xcc, fn(acc, i) {
            list.range(1, len)
            |> list.fold_until(acc, fn(acc2, j) {
              let #(start, steps) = acc2
              let sub = slice(start, i, j)
              case dict.get(replacements, sub) {
                Ok(to) -> {
                  let new_start =
                    slice(start, 0, i) <> to <> slice(start, j + i, len)
                  list.Stop(#(new_start, steps + 1))
                }
                _ -> {
                  list.Continue(#(start, steps))
                }
              }
            })
            |> list.Continue
          })
          |> list.Continue
        }
      }
    })

  let #(_, x) = steps
  x
}

pub fn part2(input: String) -> Int {
  let #(start, replacements) = parse(input)
  let r =
    list.map(replacements, fn(x) {
      #(x.to |> string.reverse, x.from |> string.reverse)
    })
    |> dict.from_list
  sythize_start(start |> string.reverse, r)
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
