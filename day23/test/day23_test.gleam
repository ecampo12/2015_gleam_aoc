import day23.{parse, run}
import gleam/dict
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

const input = "inc a
jio a, +2
tpl a
inc a"

pub fn run_test() {
  let registers = [#("a", 0), #("b", 0)] |> dict.from_list
  let output = parse(input) |> run(registers, _, 0)
  let assert Ok(ans) = dict.get(output, "a")
  should.equal(ans, 2)

  let registers = [#("a", 1), #("b", 0)] |> dict.from_list
  let output = parse(input) |> run(registers, _, 0)
  let assert Ok(ans) = dict.get(output, "a")
  should.equal(ans, 7)
}
