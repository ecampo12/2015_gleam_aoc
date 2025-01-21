import day12.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  "[1,2,3]" |> part1 |> should.equal(6)
  "{\"a\":2,\"b\":4}" |> part1 |> should.equal(6)
  "[[[3]]]" |> part1 |> should.equal(3)
  "{\"a\":{\"b\":4},\"c\":-1}" |> part1 |> should.equal(3)
}

pub fn part2_test() {
  "[1,2,3]" |> part1 |> should.equal(6)
  "[1,{\"c\":\"red\",\"b\":2},3]" |> part2 |> should.equal(4)
  "{\"d\":\"red\",\"e\":[1,2,3,4],\"f\":5}" |> part2 |> should.equal(0)
  "[1,\"red\",5]" |> part2 |> should.equal(6)
}
