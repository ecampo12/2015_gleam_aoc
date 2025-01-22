import day15.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const input = "Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3"

pub fn part1_test() {
  part1(input) |> should.equal(62_842_880)
}

pub fn part2_test() {
  part2(input) |> should.equal(57_600_000)
}
