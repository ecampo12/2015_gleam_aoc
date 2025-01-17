import day04.{part1}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn abcdef_key_test() {
  let expected = 609_043
  let actual = "abcdef" |> part1
  should.equal(actual, expected)
}

pub fn pqrstuv_key_test() {
  let expected = 1_048_970
  let actual = "pqrstuv" |> part1
  should.equal(actual, expected)
}
