import gleam/io
import gleam/list
import gleam/regexp
import gleam/string
import simplifile.{read}

pub fn part1(input: String) -> Int {
  let assert Ok(hex) = regexp.from_string("\\\\x[0-9a-f]{2}")
  let line =
    input
    |> string.replace("\\\\", "X")
    |> regexp.replace(hex, _, "X")
    |> string.replace("\"", "")

  string.length(input) - string.length(line)
}

pub fn part2(input: String) -> Int {
  let count =
    string.to_graphemes(input)
    |> list.filter(fn(x) { x == "\"" || x == "\\" })
    |> list.length
  count + 2 * list.length(string.split(input, "\n"))
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
