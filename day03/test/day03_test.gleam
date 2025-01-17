import day03.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn two_houses_test() {
  let expected = 2
  let actual = part1(">")
  should.equal(actual, expected)

  let actual = part1("^v^v^v^v^v")
  should.equal(actual, expected)
}

pub fn four_houses_test() {
  let expected = 4
  let actual = part1("^>v<")
  should.equal(actual, expected)
}

pub fn two_santas_three_houses_test() {
  let expected = 3
  let actual = part2("^v")
  should.equal(actual, expected)

  let actual = part2("^>v<")
  should.equal(actual, expected)
}

pub fn two_santas_multiple_houses_test() {
  let expected = 11
  let actual = part2("^v^v^v^v^v")
  should.equal(actual, expected)
}
