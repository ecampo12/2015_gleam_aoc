import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import glearray.{type Array}
import simplifile.{read}

pub type Instruction {
  Instruction(op: String, register: String, offset: Int)
}

// used glearray instead of gary since all I'm doing is looking up indices in the array.
pub fn parse(ipnut: String) -> Array(Instruction) {
  string.split(ipnut, "\n")
  |> list.map(fn(x) {
    case string.split(x, " ") {
      [op, x] ->
        case op == "jmp" {
          False -> Instruction(op, x, 0)
          True -> {
            let assert Ok(num) = int.parse(x)
            Instruction(op, "", num)
          }
        }
      [op, r, offset] -> {
        let assert Ok(num) = int.parse(offset)
        Instruction(op, string.drop_end(r, 1), num)
      }
      _ -> Instruction("", "", 0)
    }
  })
  |> glearray.from_list
}

pub fn run(
  registers: Dict(String, Int),
  ops: Array(Instruction),
  ip: Int,
) -> Dict(String, Int) {
  case ip < glearray.length(ops) {
    False -> registers
    True ->
      case glearray.get(ops, ip) {
        Error(_) -> registers
        Ok(instruction) ->
          case instruction.op {
            "hlf" -> {
              let assert Ok(r) = dict.get(registers, instruction.register)
              dict.insert(registers, instruction.register, r / 2)
              |> run(ops, ip + 1)
            }
            "tpl" -> {
              let assert Ok(r) = dict.get(registers, instruction.register)
              dict.insert(registers, instruction.register, r * 3)
              |> run(ops, ip + 1)
            }
            "inc" -> {
              let assert Ok(r) = dict.get(registers, instruction.register)
              dict.insert(registers, instruction.register, r + 1)
              |> run(ops, ip + 1)
            }
            "jmp" -> run(registers, ops, ip + instruction.offset)
            "jie" -> {
              let assert Ok(r) = dict.get(registers, instruction.register)
              case r % 2 == 0 {
                True -> run(registers, ops, ip + instruction.offset)
                False -> run(registers, ops, ip + 1)
              }
            }
            "jio" -> {
              let assert Ok(r) = dict.get(registers, instruction.register)
              case r == 1 {
                True -> run(registers, ops, ip + instruction.offset)
                False -> run(registers, ops, ip + 1)
              }
            }
            _ -> registers
          }
      }
  }
}

pub fn part1(input: String) -> Int {
  let registers = [#("a", 0), #("b", 0)] |> dict.from_list
  let output = parse(input) |> run(registers, _, 0)
  let assert Ok(ans) = dict.get(output, "b")
  ans
}

pub fn part2(input: String) -> Int {
  let registers = [#("a", 1), #("b", 0)] |> dict.from_list
  let output = parse(input) |> run(registers, _, 0)
  let assert Ok(ans) = dict.get(output, "b")
  ans
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
