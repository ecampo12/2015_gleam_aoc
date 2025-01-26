import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import item_shop.{type Loadout}
import simplifile.{read}

type Character {
  Character(hp: Int, damage: Int, armor: Int)
}

fn reset() {
  Character(100, 0, 0)
}

fn equip(char: Character, loadout: Loadout) -> Character {
  let armor = loadout.armor.armor + loadout.ring1.armor + loadout.ring2.armor
  let damage =
    loadout.weapon.damage + loadout.ring1.damage + loadout.ring2.damage
  Character(char.hp, damage, armor)
}

fn setup_boss(input: String) -> Character {
  let assert Ok(re) = regexp.from_string("\\d+")
  let vals =
    list.map(regexp.scan(re, input), fn(x) {
      let assert Ok(num) = x.content |> int.parse
      num
    })
  case vals {
    [hp, damage, armor] -> Character(hp, damage, armor)
    _ -> Character(0, 0, 0)
  }
}

fn fight(
  player: Character,
  boss: Character,
  player_damage: Int,
  boss_damage: Int,
) -> Bool {
  let p = Character(..player, hp: player.hp - boss_damage)
  let b = Character(..boss, hp: boss.hp - player_damage)

  case boss.hp <= 0, player.hp <= 0 {
    True, _ -> True
    _, True -> False
    _, _ -> fight(p, b, player_damage, boss_damage)
  }
}

pub fn part1(input: String) -> Int {
  let boss = setup_boss(input)
  item_shop.all_equipment_loadouts()
  |> list.fold_until(0, fn(acc, x) {
    let armed_player = reset() |> equip(x)
    let player_damage = int.max(armed_player.damage - boss.armor, 1)
    let boss_damage = int.max(boss.damage - armed_player.armor, 1)
    case fight(armed_player, boss, player_damage, boss_damage) {
      True -> list.Stop(x.total_cost)
      False -> list.Continue(acc)
    }
  })
}

pub fn part2(input: String) -> Int {
  let boss = setup_boss(input)
  item_shop.all_equipment_loadouts()
  |> list.reverse
  |> list.fold_until(0, fn(acc, x) {
    let armed_player = reset() |> equip(x)
    let player_damage = int.max(armed_player.damage - boss.armor, 1)
    let boss_damage = int.max(boss.damage - armed_player.armor, 1)
    case !fight(armed_player, boss, player_damage, boss_damage) {
      True -> list.Stop(x.total_cost)
      False -> list.Continue(acc)
    }
  })
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
