import day06.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn turn_all_on_test() {
  "turn on 0,0 through 999,999" |> part1 |> should.equal(1_000_000)
}

pub fn toggle_first_row_test() {
  "toggle 0,0 through 999,0" |> part1 |> should.equal(1000)
}

pub fn turn_off_mid_four_test() {
  "turn off 499,499 through 500,500" |> part1 |> should.equal(0)
}

pub fn multi_instruction_test() {
  "turn on 0,0 through 999,999\ntoggle 0,0 through 999,0\nturn off 499,499 through 500,500"
  |> part1
  |> should.equal(998_996)
}

pub fn turn_on_one_test() {
  "turn on 0,0 through 0,0" |> part2 |> should.equal(1)
}

pub fn toggle_all_test() {
  "toggle 0,0 through 999,999" |> part2 |> should.equal(2_000_000)
}

pub fn part2_test() {
  "turn on 0,0 through 0,0\ntoggle 0,0 through 999,999"
  |> part2
  |> should.equal(2_000_001)
}
