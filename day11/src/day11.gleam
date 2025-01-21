import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/regexp
import gleam/string.{slice}
import simplifile.{read}

const alphabet = "abcdefghijklmnopqrstuvwxyz"

pub fn is_valid(str: String) -> Bool {
  let assert Ok(three_consecutive) =
    alphabet
    |> string.to_graphemes
    |> list.window(3)
    |> list.fold("", fn(acc, x) { acc <> string.concat(x) <> "|" })
    |> string.append("abc")
    |> regexp.from_string
  let assert Ok(forbiden_letters) = regexp.from_string("[iol]")
  let assert Ok(pairs) = regexp.from_string("(.)\\1.*(.)\\2")

  regexp.check(three_consecutive, str)
  && !regexp.check(forbiden_letters, str)
  && regexp.check(pairs, str)
}

fn increament_char(char: String, letters: Dict(String, String)) -> String {
  case char {
    "z" -> "a"
    "i" -> "j"
    "o" -> "p"
    "l" -> "m"
    _ -> {
      let assert Ok(a) = dict.get(letters, char)
      a
    }
  }
}

pub fn next_password(str: String, letters: Dict(String, String)) -> String {
  let rev = string.reverse(str)
  let next =
    case string.starts_with(rev, "z") {
      False -> {
        let assert Ok(a) = string.first(rev)
        increament_char(a, letters) <> slice(rev, 1, string.length(str) - 1)
      }
      True -> {
        let count =
          string.reverse(str)
          |> string.to_graphemes
          |> list.take_while(fn(x) { x == "z" })
          |> list.length
        let rest = slice(rev, count, string.length(str))
        let assert Ok(inc) = string.first(rest)
        let x = slice(rest, 1, string.length(rest))
        string.repeat("a", count) <> increament_char(inc, letters) <> x
      }
    }
    |> string.reverse

  case is_valid(next) {
    True -> next
    False -> next_password(next, letters)
  }
}

pub fn part1(input: String) -> String {
  let letters =
    string.to_graphemes(alphabet) |> list.window_by_2 |> dict.from_list
  next_password(input, letters)
}

pub fn main() {
  let assert Ok(input) = read("input.txt")
  let part1_ans = part1(input)
  io.print("Part 1: ")
  io.debug(part1_ans)
  let part2_ans = part1(part1_ans)
  io.print("Part 2: ")
  io.debug(part2_ans)
}
