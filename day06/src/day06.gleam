import gleam/dict.{filter, from_list, get, insert, size}
import gleam/int
import gleam/io
import gleam/list.{fold, map}
import gleam/option.{Some}
import gleam/regexp
import gleam/string
import simplifile.{read}

type Instruction {
  Instruction(op: String, start: #(Int, Int), end: #(Int, Int))
}

fn new(op: String, start: String, end: String) -> Instruction {
  let get_coords = fn(s: String) -> #(Int, Int) {
    case string.split(s, ",") {
      [x, y] -> {
        let assert Ok(a) = int.parse(x)
        let assert Ok(b) = int.parse(y)
        #(a, b)
      }
      _ -> #(-1, -1)
    }
  }

  Instruction(op, get_coords(start), get_coords(end))
}

fn parse(input: String) -> List(Instruction) {
  let assert Ok(re) =
    regexp.from_string("(on|off|toggle) (\\d+,\\d+) through (\\d+,\\d+)")
  string.split(input, "\n")
  |> map(fn(x) {
    let assert Ok(match) = list.first(regexp.scan(re, x))
    case match.submatches {
      [Some(op), Some(start), Some(end)] -> new(op, start, end)
      _ -> Instruction("", #(-1, -1), #(-1, -1))
    }
  })
}

fn gernerate_coords(start: #(Int, Int), end: #(Int, Int)) -> List(#(Int, Int)) {
  let #(x, y) = start
  let #(x2, y2) = end
  list.range(x, x2)
  |> list.flat_map(fn(x) {
    list.range(y, y2)
    |> map(fn(y) { #(x, y) })
  })
}

// both are really slow, but thats what we get for working on million lights
pub fn part1(input: String) -> Int {
  let instructions = parse(input)
  let lights =
    gernerate_coords(#(0, 0), #(1000, 1000))
    |> map(fn(x) { #(x, False) })
    |> from_list
  fold(instructions, lights, fn(acc, x) {
    let coords = gernerate_coords(x.start, x.end)
    case x.op {
      "on" -> fold(coords, acc, fn(bcc, x) { insert(bcc, x, True) })
      "off" -> fold(coords, acc, fn(bcc, x) { insert(bcc, x, False) })
      "toggle" -> {
        fold(coords, acc, fn(bcc, x) {
          let assert Ok(t) = get(bcc, x)
          insert(bcc, x, !t)
        })
      }
      _ -> acc
    }
  })
  |> filter(fn(_k, v) { v })
  |> size
}

pub fn part2(input: String) -> Int {
  let instructions = parse(input)
  let lights =
    gernerate_coords(#(0, 0), #(1000, 1000))
    |> map(fn(x) { #(x, 0) })
    |> from_list
  fold(instructions, lights, fn(acc, x) {
    let coords = gernerate_coords(x.start, x.end)
    case x.op {
      "on" ->
        fold(coords, acc, fn(bcc, x) {
          let assert Ok(t) = get(bcc, x)
          insert(bcc, x, t + 1)
        })
      "off" ->
        fold(coords, acc, fn(bcc, x) {
          let assert Ok(t) = get(bcc, x)
          let c = int.max(t - 1, 0)
          insert(bcc, x, c)
        })
      "toggle" -> {
        fold(coords, acc, fn(bcc, x) {
          let assert Ok(t) = get(bcc, x)
          insert(bcc, x, t + 2)
        })
      }
      _ -> acc
    }
  })
  |> dict.fold(0, fn(acc, _k, v) { acc + v })
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
