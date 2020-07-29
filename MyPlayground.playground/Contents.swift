func scoreCheck() {
  let scores = [100, 85, 90]
  let formatted = scores.map {
    "Your score was \($0)"
  }
    print(formatted)
  }
  scoreCheck()

func dogNames(names: [String]) -> [String] {
  return names.map {
    $0.uppercased()
  }
}
let dogs = ["kona", "riley", "wally"]
print(dogNames(names: dogs))



func dogYears(ages: [Int]) -> [Int] {
  return ages.map { $0 * 7 }
}
print(dogYears(ages: [7, 5, 3]))

func Letters(names: [String]) -> [Int] {
  return names.map {$0.count}
  }

print(Letters(names: ["Harry", "Sally", "Wally"]))

func ships(name: [String]) -> [String] {
  return name.map { $0.lowercased()}
}
let shipNames = ["Merry", "Sunny", "Moby Dick"]

print(ships(name: shipNames))

