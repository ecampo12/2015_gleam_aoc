import day18.{part1, part2}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  let input =
    ".#.#.#
...##.
#....#
..#...
#.#..#
####.."
  part1(input, 4) |> should.equal(4)
}

pub fn part2_test() {
  let input =
    "##.#.#
...##.
#....#
..#...
#.#..#
####.#"
  part2(input, 5) |> should.equal(17)
}
