import day17.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const input = "20
15
10
5
5"

pub fn part1_test() {
  part1(input, 25) |> should.equal(4)
}

pub fn part2_test() {
  part2(input, 25) |> should.equal(3)
}
