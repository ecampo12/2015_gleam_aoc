import day24.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const input = "1
2
3
4
5
7
8
9
10
11"

pub fn part1_test() {
  input |> part1 |> should.equal(99)
}

pub fn part2_test() {
  input |> part2 |> should.equal(44)
}
