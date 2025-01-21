import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/order
import gleam/regexp
import gleam/string
import simplifile.{read}

type Reindeer {
  Reindeer(name: String, speed: Int, flytime: Int, rest_time: Int)
}

fn parse(input: String) -> List(Reindeer) {
  let assert Ok(re) =
    regexp.from_string(
      "(\\w+) can fly (\\d+) km/s for (\\d+) seconds, but then must rest for (\\d+) seconds.",
    )
  string.split(input, "\n")
  |> list.map(fn(x) {
    case regexp.scan(re, x) {
      [match] ->
        case match.submatches {
          [Some(name), Some(speed), Some(flytime), Some(rest_time)] -> {
            let assert Ok(a) = int.parse(speed)
            let assert Ok(b) = int.parse(flytime)
            let assert Ok(c) = int.parse(rest_time)
            Reindeer(name, a, b, c)
          }
          _ -> Reindeer("", -1, -1, -1)
        }
      _ -> Reindeer("", -1, -1, -1)
    }
  })
}

fn calculate_distance(reindeer: Reindeer, time: Int) -> Int {
  let cycletime = reindeer.flytime + reindeer.rest_time
  let cycles = time / cycletime
  let remaining_time = time % cycletime
  { cycles * reindeer.flytime + int.min(reindeer.flytime, remaining_time) }
  * reindeer.speed
}

fn compare_distances(a: #(String, Int), b: #(String, Int)) -> order.Order {
  let #(_, d1) = a
  let #(_, d2) = b
  int.compare(d1, d2)
}

pub fn part1(input: String, racetime: Int) -> Int {
  let distances =
    parse(input)
    |> list.map(fn(r) { calculate_distance(r, racetime) })
    |> list.sort(int.compare)
  let assert Ok(further) = list.last(distances)
  further
}

pub fn part2(input: String, racetime: Int) -> Int {
  let reindeers = parse(input)
  let points =
    list.map(reindeers, fn(x) { #(x.name, 0) })
    |> dict.from_list
  let high_score =
    list.range(1, racetime)
    |> list.fold(points, fn(acc, time) {
      let distances =
        list.map(reindeers, fn(r) { #(r.name, calculate_distance(r, time)) })
        |> list.sort(compare_distances)

      let assert Ok(#(_, furthest)) = list.last(distances)
      let award = list.filter(distances, fn(x) { x.1 == furthest })

      list.fold(award, acc, fn(bcc, x) {
        let #(name, _) = x
        let assert Ok(p) = dict.get(bcc, name)
        dict.insert(bcc, name, p + 1)
      })
    })
    |> dict.to_list
    |> list.sort(compare_distances)
  let assert Ok(#(_, winner)) = list.last(high_score)
  winner
}

pub fn main() {
  let assert Ok(input) = read("input.txt")
  let part1_ans = part1(input, 2503)
  io.print("Part 1: ")
  io.debug(part1_ans)
  let part2_ans = part2(input, 2503)
  io.print("Part 2: ")
  io.debug(part2_ans)
}
