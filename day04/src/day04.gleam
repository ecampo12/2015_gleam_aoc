import gleam/bit_array
import gleam/crypto
import gleam/int
import gleam/io
import gleam/string
import simplifile.{read}

fn hash(str: String) -> String {
  bit_array.from_string(str)
  |> crypto.hash(crypto.Md5, _)
  |> bit_array.base16_encode
}

fn mine(value: String, count: Int, check: String) -> Int {
  case string.starts_with(hash(value <> int.to_string(count)), check) {
    True -> count
    False -> mine(value, count + 1, check)
  }
}

pub fn part1(input: String) -> Int {
  mine(input, 0, "00000")
}

pub fn part2(input: String) -> Int {
  mine(input, 0, "000000")
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
