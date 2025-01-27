import day25.{get_triangle_code, part1}
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn get_triangle_code_test() {
  let coords = [
    #(1, 1),
    #(2, 1),
    #(1, 2),
    #(1, 6),
    #(4, 3),
    #(4, 1),
    #(3, 3),
    #(3, 4),
    #(2, 2),
  ]
  let expected = [1, 2, 3, 21, 18, 7, 13, 19, 5]
  list.zip(coords, expected)
  |> list.map(fn(x) {
    let #(c, e) = x
    get_triangle_code(c)
    |> should.equal(e)
  })
}

pub fn part1_test() {
  part1("6 6") |> should.equal(27_995_004)
}
