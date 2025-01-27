import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

// For our input it turns out that the first valid grouping we find happends to be the grouping with 
// the lowest quantum entanglement. Since we are searching for smallest to largest groupping length, the fist answer is
// the correct one. Because of this we can exit when we find somehting.
// This is great because list.combinations blows up our memory usage, sice it returns all possible combinations.
fn groups(input: String, groupping: Int) -> Int {
  let nums =
    string.split(input, "\n")
    |> list.map(fn(x) {
      let assert Ok(v) = int.parse(x)
      v
    })
  let sum = int.sum(nums) / groupping
  list.range(2, list.length(nums) / groupping)
  |> list.fold_until(0, fn(acc, x) {
    let q =
      list.combinations(nums, x)
      |> list.fold_until(acc, fn(bcc, combo) {
        case int.sum(combo) == sum {
          True -> list.Stop(int.product(combo))
          False -> list.Continue(bcc)
        }
      })
    case q == 0 {
      False -> list.Stop(q)
      True -> list.Continue(acc)
    }
  })
}

pub fn part1(input: String) -> Int {
  groups(input, 3)
}

pub fn part2(input: String) -> Int {
  groups(input, 4)
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
