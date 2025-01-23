import gleam/dict.{type Dict, insert}
import gleam/int
import gleam/io
import gleam/list.{fold}
import gleam/string

import simplifile.{read}

type Point {
  Point(row: Int, col: Int)
}

fn add(p1: Point, p2: Point) -> Point {
  Point(p1.row + p2.row, p1.col + p2.col)
}

const neighbors = [
  Point(-1, 0),
  Point(-1, -1),
  Point(-1, 1),
  Point(0, -1),
  Point(0, 1),
  Point(1, -1),
  Point(1, 0),
  Point(1, 1),
]

fn parse(input: String) -> #(Dict(Point, Bool), List(Point)) {
  let parsed =
    string.split(input, "\n")
    |> list.index_map(fn(row, r) {
      string.to_graphemes(row)
      |> list.index_map(fn(col, c) { #(Point(r, c), col == "#") })
    })
    |> list.flatten
  let points =
    list.map(parsed, fn(x) {
      let #(p, _) = x
      p
    })

  #(dict.from_list(parsed), points)
}

fn check_neighbors(grid: Dict(Point, Bool), curr: Point) -> Int {
  list.map(neighbors, fn(x) {
    let p = add(curr, x)
    case dict.get(grid, p) {
      Ok(True) -> 1
      Ok(False) -> 0
      Error(_) -> 0
    }
  })
  |> int.sum
}

// Builds the grid for the next step using the given grid/
fn update_light(grid: Dict(Point, Bool), points: List(Point)) {
  fold(points, grid, fn(acc, x) {
    let count = check_neighbors(grid, x)
    let assert Ok(b) = dict.get(grid, x)
    let update = case b, count {
      True, 2 | True, 3 -> True
      False, 3 -> True
      _, _ -> False
    }
    insert(acc, x, update)
  })
}

pub fn part1(input: String, step: Int) -> Int {
  let #(grid, points) = parse(input)
  list.range(1, step)
  |> fold(grid, fn(acc, _p) { update_light(acc, points) })
  |> dict.filter(fn(_p, b) { b })
  |> dict.size
}

pub fn part2(input: String, step: Int) -> Int {
  let len = string.split(input, "\n") |> list.length
  let always_on = [
    Point(0, 0),
    Point(0, len - 1),
    Point(len - 1, 0),
    Point(len - 1, len - 1),
  ]

  let #(grid, points) = parse(input)

  let updated = fold(always_on, grid, fn(bcc, x) { insert(bcc, x, True) })
  list.range(1, step)
  |> fold(updated, fn(acc, _p) {
    update_light(acc, points)
    |> fold(always_on, _, fn(bcc, x) { insert(bcc, x, True) })
  })
  |> dict.filter(fn(_p, b) { b })
  |> dict.size
}

pub fn main() {
  let assert Ok(input) = read("input.txt")
  let part1_ans = part1(input, 100)
  io.print("Part 1: ")
  io.debug(part1_ans)
  let part2_ans = part2(input, 100)
  io.print("Part 2: ")
  io.debug(part2_ans)
}
