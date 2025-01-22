import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import gleam/string
import simplifile.{read}

type Sue {
  Sue(id: Int, properties: List(#(String, Int)))
}

const clues = [
  #("children", 3),
  #("cats", 7),
  #("samoyeds", 2),
  #("pomeranians", 3),
  #("akitas", 0),
  #("vizslas", 0),
  #("goldfish", 5),
  #("trees", 3),
  #("cars", 2),
  #("perfumes", 1),
]

fn str_to_int(str: String) -> Int {
  case int.parse(str) {
    Ok(x) -> x
    Error(_) -> 0
  }
}

fn parse(input: String) -> List(Sue) {
  let assert Ok(sue) = regexp.from_string("Sue (\\d+)")
  let assert Ok(re) = regexp.from_string("(\\w+: \\d+)")
  string.split(input, "\n")
  |> list.map(fn(x) {
    let id = case regexp.scan(sue, x) {
      [match] ->
        case match.submatches {
          [Some(num)] -> str_to_int(num)
          _ -> 0
        }
      _ -> 0
    }

    let props =
      regexp.scan(re, x)
      |> list.map(fn(prop) {
        case prop {
          match ->
            case string.split(match.content, ": ") {
              [key, value] -> #(key, str_to_int(value))
              _ -> #("", 0)
            }
        }
      })
    Sue(id, props)
  })
}

pub fn part1(input: String) -> Int {
  let search = clues |> dict.from_list
  let found =
    parse(input)
    |> list.filter(fn(x) {
      list.map(x.properties, fn(p) {
        let #(prop, val) = p
        let assert Ok(v) = dict.get(search, prop)
        v == val
      })
      |> list.all(fn(b) { b })
    })
  let assert Ok(sue) = list.first(found)
  sue.id
}

pub fn part2(input: String) -> Int {
  let search = clues |> dict.from_list
  let found =
    parse(input)
    |> list.filter(fn(x) {
      list.map(x.properties, fn(p) {
        let #(prop, val) = p
        let assert Ok(v) = dict.get(search, prop)
        case prop {
          "cats" | "trees" -> val > v
          "pomeranians" | "goldfish" -> val < v
          _ -> v == val
        }
      })
      |> list.all(fn(b) { b })
    })
  let assert Ok(sue) = list.first(found)
  sue.id
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
