import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import gleam/string
import simplifile.{read}

fn parse(input: String) -> #(List(String), Dict(#(String, String), Int)) {
  let assert Ok(re) =
    regexp.from_string(
      "(\\w+) would (gain|lose) (\\d+) happiness units by sitting next to (\\w+).",
    )
  let data =
    string.split(input, "\n")
    |> list.map(fn(x) {
      case regexp.scan(re, x) {
        [match] ->
          case match.submatches {
            [Some(name1), Some("gain"), Some(num), Some(name2)] -> {
              let assert Ok(n) = int.parse(num)
              #(#(name1, name2), n)
            }
            [Some(name1), Some("lose"), Some(num), Some(name2)] -> {
              let assert Ok(n) = int.parse(num)
              #(#(name1, name2), -n)
            }
            _ -> #(#("", ""), 0)
          }
        _ -> #(#("", ""), 0)
      }
    })
  let guests =
    list.map(data, fn(x) {
      let #(#(name, _), _) = x
      name
    })
    |> list.unique

  #(guests, dict.from_list(data))
}

fn calculate_happiness(
  guests: List(String),
  nodes: Dict(#(String, String), Int),
) -> List(Int) {
  list.permutations(guests)
  |> list.map(fn(x) {
    let assert Ok(first) = list.first(x)
    list.append(x, [first])
    |> list.window_by_2
    |> list.fold(0, fn(acc, x) {
      let #(g1, g2) = x
      let assert Ok(num1) = dict.get(nodes, x)
      let assert Ok(num2) = dict.get(nodes, #(g2, g1))
      acc + num1 + num2
    })
  })
}

pub fn part1(input: String) -> Int {
  let #(guests, nodes) = parse(input)
  let scores =
    calculate_happiness(guests, nodes)
    |> list.sort(int.compare)
  let assert Ok(optimize) = list.last(scores)
  optimize
}

pub fn part2(input: String) -> Int {
  let #(guests, nodes) = parse(input)
  let updated_guests = list.append(guests, ["Me"])
  let updated_nodes =
    list.fold(guests, nodes, fn(acc, x) {
      dict.insert(acc, #(x, "Me"), 0) |> dict.insert(#("Me", x), 0)
    })
  let scores =
    calculate_happiness(updated_guests, updated_nodes)
    |> list.sort(int.compare)
  let assert Ok(optimize) = list.last(scores)
  optimize
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
