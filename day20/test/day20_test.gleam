import day20.{part1, part2}
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  let tests = [#("70", 4), #("120", 6), #("150", 8)]
  list.map(tests, fn(t) {
    let #(input, expected) = t
    let actual = part1(input)
    should.equal(actual, expected)
  })
}

pub fn part2_test() {
  let input = "70"
  let actual = part2(input)
  should.equal(actual, 4)
}
