import day08.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  "\"\"" |> part1 |> should.equal(2)
  "\"abc\"" |> part1 |> should.equal(2)
  "\"aaa\\\"aaa\"" |> part1 |> should.equal(3)
  "\"\\x27\"" |> part1 |> should.equal(5)
  "\"\"\n\"abc\"\n\"aaa\\\"aaa\"\n\"\\x27\""
  |> part1
  |> should.equal(12)
}

pub fn part2_test() {
  "\"\"" |> part2 |> should.equal(4)
  "\"abc\"" |> part2 |> should.equal(4)
  "\"aaa\\\"aaa\"" |> part2 |> should.equal(6)
  "\"\\x27\"" |> part2 |> should.equal(5)
  "\"\"\n\"abc\"\n\"aaa\\\"aaa\"\n\"\\x27\""
  |> part2
  |> should.equal(19)
}
