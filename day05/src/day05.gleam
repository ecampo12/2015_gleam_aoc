import gleam/io
import gleam/list
import gleam/regexp
import gleam/string
import simplifile.{read}

pub fn part1(input: String) -> Int {
  let assert Ok(vowels) = regexp.from_string("[a|e|i|o|u]")
  let assert Ok(forbidden_strs) = regexp.from_string("ab|cd|pq|xy")
  let assert Ok(repeat) = regexp.from_string("(.)\\1{1,}")

  string.split(input, "\n")
  |> list.filter(fn(x) {
    let safe_vowels = list.length(regexp.scan(vowels, x)) >= 3
    let safe_strs = regexp.check(forbidden_strs, x)
    let safe_repeat = regexp.check(repeat, x)

    safe_vowels && !safe_strs && safe_repeat
  })
  |> list.length
}

pub fn part2(input: String) -> Int {
  let assert Ok(twice_no_overlap) = regexp.from_string("(.{2}).*?(\\1)")
  let assert Ok(repeated_once) = regexp.from_string("(.).\\1")

  string.split(input, "\n")
  |> list.filter(fn(x) {
    regexp.check(twice_no_overlap, x) && regexp.check(repeated_once, x)
  })
  |> list.length
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
