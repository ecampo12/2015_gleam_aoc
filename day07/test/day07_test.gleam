import day07.{circuit, find_nums, parse}
import gleam/dict
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  let expected = [
    #("d", 72),
    #("e", 507),
    #("f", 492),
    #("g", 114),
    #("h", 65_412),
    #("i", 65_079),
    #("x", 123),
    #("y", 456),
  ]
  let input =
    "123 -> x\n456 -> y\nx AND y -> d\nx OR y -> e\nx LSHIFT 2 -> f\ny RSHIFT 2 -> g\nNOT x -> h\nNOT y -> i"
  let wires = find_nums(input)
  let actual =
    input
    |> parse
    |> circuit(wires, -1)

  list.map(expected, fn(x) {
    let #(key, expected_val) = x
    let assert Ok(actual_val) = dict.get(actual, key)
    should.equal(actual_val, expected_val)
  })
}
