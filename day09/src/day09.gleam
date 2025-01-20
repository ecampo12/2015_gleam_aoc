import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

fn parse(input: String) -> List(#(String, String, Int)) {
  input
  |> string.split("\n")
  |> list.fold([], fn(acc, x) {
    case string.split(x, " ") {
      [start, _, destination, _, distance] -> {
        let assert Ok(d) = int.parse(distance)
        [#(start, destination, d), #(destination, start, d), ..acc]
      }
      _ -> acc
    }
  })
}

fn distances(
  nodes: List(#(String, String, Int)),
) -> Dict(#(String, String), Int) {
  nodes
  |> list.map(fn(x) {
    let #(a, b, c) = x
    #(#(a, b), c)
  })
  |> dict.from_list
}

fn find_all_distances(
  cities: List(String),
  distances: Dict(#(String, String), Int),
) -> List(Int) {
  list.permutations(cities)
  |> list.map(fn(route) {
    list.window(route, 2)
    |> list.fold(0, fn(acc, pair) {
      case pair {
        [x, y] -> {
          let assert Ok(distance) = dict.get(distances, #(x, y))
          acc + distance
        }
        _ -> 0
      }
    })
  })
  |> list.sort(int.compare)
}

pub fn part1(input: String) -> Int {
  let nodes = input |> parse
  let cities = nodes |> list.map(fn(x) { x.0 }) |> list.unique
  let distances = distances(nodes)
  let assert Ok(shortest) =
    find_all_distances(cities, distances)
    |> list.first
  shortest
}

pub fn part2(input: String) -> Int {
  let nodes = input |> parse
  let cities = nodes |> list.map(fn(x) { x.0 }) |> list.unique
  let distances = distances(nodes)
  let assert Ok(longest) =
    find_all_distances(cities, distances)
    |> list.last
  longest
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
