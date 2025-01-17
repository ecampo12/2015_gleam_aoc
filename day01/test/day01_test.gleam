import day01.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn zero_floors_test() {
  "(())" |> part1 |> should.equal(0)
  "()()" |> part1 |> should.equal(0)
}

pub fn three_floors_test() {
  "(((" |> part1 |> should.equal(3)
  "(()(()(" |> part1 |> should.equal(3)
  "))(((((" |> part1 |> should.equal(3)
}

pub fn negative_floors_test() {
  "())" |> part1 |> should.equal(-1)
  "))(" |> part1 |> should.equal(-1)
  ")))" |> part1 |> should.equal(-3)
  ")())())" |> part1 |> should.equal(-3)
}

pub fn first_negative_test() {
  ")" |> part2 |> should.equal(1)
  "()())" |> part2 |> should.equal(5)
}
