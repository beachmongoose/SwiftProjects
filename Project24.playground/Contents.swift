//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSMutableAttributedString(string: string)
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

//let attributedString = NSAttributedString(string: string, attributes: attributes)


extension String {
    func addingPrefix(_ prefix: String) -> String {
      guard !self.isEmpty && !self.hasPrefix(prefix) else { return self }
    return String(prefix + self)
  }
}

let wordArray = ["pet", "bine", "carton", "cinogen"]
let word = "pet"

let formattedWord = word.addingPrefix("car")

func formatArray(_ array: [String]) -> [String] {
  return array.map {
    $0.addingPrefix("car")
  }
}
print(formatArray(wordArray))

let numArray = ["1", "2", "apple", "3"]
let num = "1"
let double = "1.23"
let notNum = "apple"

extension String {
  func isNumeric() -> Bool {
    guard !self.isEmpty else { return false }
    if Int(self) != nil || Double(self) != nil {
      return true
    }
    return false
  }
}

print(double.isNumeric())
print(num.isNumeric())
print(notNum.isNumeric())

let testString = "this\nis\na\ntest"

extension String {
  func lines() -> [String] {
    return self.components(separatedBy: "\n")
  }
}

print(testString.lines())

let languages = ["Python", "Ruby", "Swift"]
let input = "Swift is like Objective-C without the C"

languages.contains("Swift")
input.contains("Swift")
// if languages contains any of the words that input contains
languages.contains(where: input.contains)
