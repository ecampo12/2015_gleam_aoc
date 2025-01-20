import day10.{look_and_say}
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn look_and_say_test() {
  let inputs = ["1", "11", "21", "1211", "111221"]
  let expected = ["11", "21", "1211", "111221", "312211"]

  list.zip(inputs, expected)
  |> list.map(fn(x) { look_and_say(x.0) |> should.equal(x.1) })
}
