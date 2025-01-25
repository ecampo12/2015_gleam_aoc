import gleam/int
import gleam/io
import gleam/list
import gleam_community/maths/arithmetics.{divisors}
import simplifile.{read}

fn find_house(target: Int, house: Int) -> Int {
  let presents =
    divisors(house)
    |> list.fold(0, fn(acc, x) { acc + 10 * x })

  case presents >= target {
    True -> house
    False -> find_house(target, house + 1)
  }
}

pub fn part1(input: String) -> Int {
  let assert Ok(target) = int.parse(input)
  find_house(target, 1)
}

fn find_finite_houses(target: Int, house: Int) -> Int {
  let presents =
    divisors(house)
    |> list.fold(0, fn(acc, x) {
      case house / x <= 50 {
        True -> acc + x * 11
        False -> acc
      }
    })

  case presents >= target {
    True -> house
    False -> find_finite_houses(target, house + 1)
  }
}

pub fn part2(input: String) -> Int {
  let assert Ok(target) = int.parse(input)
  find_finite_houses(target, 1)
}

pub fn main() {
  let assert Ok(input) = read("input.txt")
  let part1_ans = part1(input)
  io.print("Part 1: ")
  io.debug(part1_ans)
  let part2_ans = part2(input)
  io.print("Part 2: ")
  io.debug(part2_ans)
}
