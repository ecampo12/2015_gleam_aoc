import day11.{is_valid, next_password}
import gleam/dict
import gleam/list
import gleam/string
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn is_valid_password_test() {
  ["hijklmmn", "abbceffg", "abbcegjk"]
  |> list.map(fn(x) { is_valid(x) |> should.be_false })
}

pub fn next_password_test() {
  let alphabet = "abcdefghijklmnopqrstuvwxyz"
  let letters =
    string.to_graphemes(alphabet) |> list.window_by_2 |> dict.from_list
  let input = ["abcdefgh"]
  let next = ["abcdffaa"]

  list.zip(input, next)
  |> list.map(fn(x) {
    let #(input, expected) = x
    let actial = next_password(input, letters)
    should.equal(actial, expected)
  })
}
