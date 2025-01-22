import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

fn find_combinations(input: String, target: Int) -> List(List(Int)) {
  let containers =
    string.split(input, "\n")
    |> list.map(fn(x) {
      let assert Ok(n) = int.parse(x)
      n
    })
  list.range(1, list.length(containers))
  |> list.map(fn(i) { list.combinations(containers, i) })
  |> list.flatten
  |> list.filter(fn(x) { int.sum(x) == target })
}

pub fn part1(input: String, target: Int) -> Int {
  find_combinations(input, target)
  |> list.length
}

pub fn part2(input: String, target: Int) -> Int {
  let lengths =
    find_combinations(input, target)
    |> list.map(fn(x) { list.length(x) })
    |> list.sort(int.compare)
  let assert Ok(min_length) = list.first(lengths)
  list.filter(lengths, fn(x) { x == min_length }) |> list.length
}

pub fn main() {
  let assert Ok(input) = read("input.txt")
  let part1_ans = part1(input, 150)
  io.print("Part 1: ")
  io.debug(part1_ans)
  let part2_ans = part2(input, 150)
  io.print("Part 2: ")
  io.debug(part2_ans)
}
