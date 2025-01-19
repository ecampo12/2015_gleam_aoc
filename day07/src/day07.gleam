import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import gleam/string
import simplifile.{read}

pub type Instruction {
  Instruction(op: String, in1: String, in2: String, out: String)
}

const ffff: Int = 65_535

pub fn parse(input: String) -> List(Instruction) {
  string.split(input, "\n")
  |> list.map(fn(x) {
    case string.split(x, " ") {
      [in1, op, in2, _, out] -> Instruction(op, in1, in2, out)
      [op, in1, _, out] -> Instruction(op, in1, "", out)
      [num, _, out] -> Instruction("INIT", num, "", out)
      _ -> Instruction("", "", "", "")
    }
  })
}

fn op_not(wires: Dict(String, Int), ints: Instruction) {
  case dict.get(wires, ints.in1) {
    Ok(val) -> {
      let x = int.bitwise_not(val) |> int.bitwise_and(ffff)
      dict.insert(wires, ints.out, x)
    }
    Error(_) -> wires
  }
}

fn op_and(wires: Dict(String, Int), ints: Instruction) {
  case dict.get(wires, ints.in1), dict.get(wires, ints.in2) {
    Ok(val), Ok(val2) -> {
      let x = int.bitwise_and(val, val2) |> int.bitwise_and(ffff)
      dict.insert(wires, ints.out, x)
    }
    _, _ -> wires
  }
}

fn op_or(wires: Dict(String, Int), ints: Instruction) {
  case dict.get(wires, ints.in1), dict.get(wires, ints.in2) {
    Ok(val), Ok(val2) -> {
      let x = int.bitwise_or(val, val2) |> int.bitwise_and(ffff)
      dict.insert(wires, ints.out, x)
    }
    _, _ -> wires
  }
}

fn op_lshift(wires: Dict(String, Int), ints: Instruction) {
  case dict.get(wires, ints.in1), dict.get(wires, ints.in2) {
    Ok(val), Ok(val2) -> {
      let x = int.bitwise_shift_left(val, val2) |> int.bitwise_and(ffff)
      dict.insert(wires, ints.out, x)
    }
    _, _ -> wires
  }
}

fn op_rshift(wires: Dict(String, Int), ints: Instruction) {
  case dict.get(wires, ints.in1), dict.get(wires, ints.in2) {
    Ok(val), Ok(val2) -> {
      let x = int.bitwise_shift_right(val, val2) |> int.bitwise_and(ffff)
      dict.insert(wires, ints.out, x)
    }
    _, _ -> wires
  }
}

pub fn circuit(
  input: List(Instruction),
  wires: Dict(String, Int),
  override: Int,
) -> Dict(String, Int) {
  let wait =
    list.filter(input, fn(x) {
      case x.op, dict.get(wires, x.in1), dict.get(wires, x.in2) {
        "INIT", _, _ -> {
          case dict.get(wires, x.in1) {
            Ok(_) -> {
              case dict.get(wires, x.out) {
                Ok(_) -> False
                Error(_) -> True
              }
            }
            Error(_) -> True
          }
        }
        "NOT", Ok(_), _ -> False
        "NOT", Error(_), _ -> True
        _, Error(_), _ -> True
        _, _, Error(_) -> True
        _, _, _ -> False
      }
    })
  let update =
    list.fold(input, wires, fn(acc, x) {
      case x.op {
        "NOT" -> op_not(acc, x)
        "AND" -> op_and(acc, x)
        "OR" -> op_or(acc, x)
        "LSHIFT" -> op_lshift(acc, x)
        "RSHIFT" -> op_rshift(acc, x)
        _ -> {
          case dict.get(acc, x.in1) {
            Ok(val) -> {
              case override, x.out {
                -1, _ -> dict.insert(acc, x.out, val)
                _, "b" -> dict.insert(acc, x.out, override)
                _, _ -> dict.insert(acc, x.out, val)
              }
            }
            Error(_) -> acc
          }
        }
      }
    })
  use <- bool.guard(when: list.is_empty(wait), return: wires)
  circuit(wait, update, override)
}

pub fn find_nums(input: String) -> Dict(String, Int) {
  let assert Ok(re) = regexp.from_string("\\d+")
  regexp.scan(re, input)
  |> list.map(fn(x) {
    let assert Ok(num) = int.parse(x.content)
    #(x.content, num)
  })
  |> dict.from_list
}

pub fn part1(input: String) -> Int {
  let wires = find_nums(input)
  let res = parse(input) |> circuit(wires, -1)
  let assert Ok(a) = dict.get(res, "a")
  a
}

pub fn part2(input: String, num: Int) -> Int {
  let wires = find_nums(input)
  let res =
    parse(input)
    |> circuit(wires, num)
  let assert Ok(a) = dict.get(res, "a")
  a
}

pub fn main() {
  let assert Ok(input) = read("input.txt")
  let part1_ans = part1(input)
  io.print("Part 1: ")
  io.debug(part1_ans)
  let part2_ans = part2(input, part1_ans)
  io.print("Part 2: ")
  io.debug(part2_ans)
}
