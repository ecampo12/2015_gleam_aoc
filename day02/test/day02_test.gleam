import day02.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn two_three_four_test() {
  "2x3x4" |> part1 |> should.equal(58)
}

pub fn one_one_ten_test() {
  "1x1x10" |> part1 |> should.equal(43)
}

pub fn two_three_four_part2_test() {
  "2x3x4" |> part2 |> should.equal(34)
}

pub fn one_one_ten_part2_test() {
  "1x1x10" |> part2 |> should.equal(14)
}
