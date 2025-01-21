import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import simplifile.{read}

pub fn part1(input: String) -> Int {
  let assert Ok(re) = regexp.from_string("-?\\d+")
  regexp.scan(re, input)
  |> list.fold(0, fn(acc, x) {
    let assert Ok(num) = int.parse(x.content)
    acc + num
  })
}

// This might be done with a json parser, but the input has mixed typed maps and arrays.
// Not sure how to handle that in gleam. So I'm using a regex to remove all objects with a "red" key.
// Got the regex from: https://www.reddit.com/r/adventofcode/comments/3wh73d/comment/cxwsgjg/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
pub fn part2(input: String) -> Int {
  let assert Ok(re) =
    regexp.from_string(
      "{(?>[^{}:]+|[^{}]+?|({(?>[^{}]+|\\g'1')*}))*:\"red(?>[^{}]+|({(?>[^{}]+|\\g'2')*}))*}",
    )
  let assert Ok(digits) = regexp.from_string("-?\\d+")
  regexp.replace(re, input, "")
  |> regexp.scan(digits, _)
  |> list.fold(0, fn(acc, x) {
    let assert Ok(num) = int.parse(x.content)
    acc + num
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
