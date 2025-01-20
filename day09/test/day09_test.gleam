import day09.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  "London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141"
  |> part1
  |> should.equal(605)
}

pub fn part2_test() {
  "London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141"
  |> part2
  |> should.equal(982)
}
