import day14.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const input = "Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds."

pub fn part1_test() {
  part1(input, 1000) |> should.equal(1120)
}

pub fn part2_test() {
  part2(input, 1000) |> should.equal(689)
}
