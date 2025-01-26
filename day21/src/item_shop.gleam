import gleam/int
import gleam/list

pub type Item {
  Item(name: String, cost: Int, damage: Int, armor: Int)
}

pub type Loadout {
  Loadout(weapon: Item, armor: Item, ring1: Item, ring2: Item, total_cost: Int)
}

const weapons = [
  Item("Dagger", 8, 4, 0),
  Item("Shortsword", 10, 5, 0),
  Item("Warhammer", 25, 6, 0),
  Item("Longsword", 40, 7, 0),
  Item("Greataxe", 74, 8, 0),
]

const armor = [
  Item("Leather", 13, 0, 1),
  Item("Chainmail", 31, 0, 2),
  Item("Splintmail", 53, 0, 3),
  Item("Bandedmail", 75, 0, 4),
  Item("Platemail", 102, 0, 5),
  Item("None", 0, 0, 0),
]

const rings = [
  Item("Damage +1", 25, 1, 0),
  Item("Damage +2", 50, 2, 0),
  Item("Damage +3", 100, 3, 0),
  Item("Defense +1", 20, 0, 1),
  Item("Defense +2", 40, 0, 2),
  Item("Defense +3", 80, 0, 3),
  Item("None1", 0, 0, 0),
  Item("None2", 0, 0, 0),
]

pub fn all_equipment_loadouts() -> List(Loadout) {
  list.fold(weapons, [], fn(wcc, w) {
    list.fold(armor, wcc, fn(acc, a) {
      list.fold(rings, acc, fn(rcc1, r1) {
        list.fold(rings, rcc1, fn(rcc2, r2) {
          case r1 != r2 {
            True ->
              list.append(rcc2, [
                Loadout(w, a, r1, r2, a.cost + w.cost + r1.cost + r2.cost),
              ])
            False -> rcc2
          }
        })
      })
    })
  })
  |> list.sort(fn(a, b) { int.compare(a.total_cost, b.total_cost) })
}
