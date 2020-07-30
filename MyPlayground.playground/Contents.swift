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


let input = ["1", "5", "Fish"]
let numbers = input.compactMap {Int($0)}
print(numbers)

let boxes = ["redline", "reddot", "redboat", "redhouse", "bluedot", "bluehouse", "bluebox"]

let redboxes = boxes.filter { $0.hasPrefix("red") }
print(redboxes)

let points = Array(1...100)
let sum = points.reduce(0,+)
print(sum)
