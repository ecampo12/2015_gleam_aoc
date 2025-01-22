import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import gleam/string
import simplifile.{read}

type Ingredient {
  Ingredient(
    capacity: Int,
    durability: Int,
    flavor: Int,
    texture: Int,
    calories: Int,
  )
}

fn parse(input: String) -> List(Ingredient) {
  let assert Ok(re) = regexp.from_string("-?\\d+")
  string.split(input, "\n")
  |> list.map(fn(x) {
    let vals =
      regexp.scan(re, x)
      |> list.map(fn(match) {
        let assert Ok(num) = int.parse(match.content)
        num
      })
    case vals {
      [c, d, f, t, cal] -> Ingredient(c, d, f, t, cal)
      _ -> Ingredient(0, 0, 0, 0, 0)
    }
  })
}

fn generate_amounts(n: Int, total: Int) -> List(List(Int)) {
  case n {
    1 -> [[total]]
    _ ->
      list.flat_map(list.range(0, total), fn(x) {
        generate_amounts(n - 1, total - x)
        |> list.map(fn(xs) { [x, ..xs] })
      })
  }
}

fn calculate_cookie(recipe: List(#(Ingredient, Int))) -> #(List(Int), Int) {
  let cookie =
    list.fold(recipe, #([0, 0, 0, 0], 0), fn(acc, x) {
      let #(ing, amount) = x
      let #(mix, cal) = acc
      case mix {
        [c, d, f, t] -> #(
          [
            c + amount * ing.capacity,
            d + amount * ing.durability,
            f + amount * ing.flavor,
            t + amount * ing.texture,
          ],
          cal + amount * ing.calories,
        )
        _ -> #([0, 0, 0, 0], 0)
      }
    })
  let #(cookie_mix, cal) = cookie
  #(list.map(cookie_mix, fn(y) { int.max(0, y) }), cal)
}

pub fn part1(input: String) -> Int {
  let ingredients = parse(input)
  let amounts =
    generate_amounts(list.length(ingredients), 100)
    |> list.map(fn(x) { list.zip(ingredients, x) })
    |> list.map(fn(x) { calculate_cookie(x) })
    |> list.map(fn(x) {
      let #(mix, _) = x
      int.product(mix)
    })
    |> list.sort(int.compare)

  let assert Ok(max) = list.last(amounts)
  max
}

pub fn part2(input: String) -> Int {
  let ingredients = parse(input)
  let amounts =
    generate_amounts(list.length(ingredients), 100)
    |> list.map(fn(x) { list.zip(ingredients, x) })
    |> list.map(fn(x) { calculate_cookie(x) })
    |> list.filter(fn(x) {
      let #(_, cal) = x
      cal == 500
    })
    |> list.map(fn(x) {
      let #(mix, _) = x
      int.product(mix)
    })
    |> list.sort(int.compare)

  let assert Ok(max) = list.last(amounts)
  max
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
