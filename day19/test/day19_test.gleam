import day19.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  "H => HO
H => OH
O => HH

HOH"
  |> part1
  |> should.equal(4)
}

pub fn part2_hoh_test() {
  "e => H
e => O
H => HO
H => OH
O => HH

HOH"
  |> part2
  |> should.equal(3)
}

pub fn part2_hohoho_test() {
  "e => H
e => O
H => HO
H => OH
O => HH

HOHOHO"
  |> part2
  |> should.equal(6)
}
