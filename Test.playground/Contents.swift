//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

let today = Date()
let formatter1 = DateFormatter()
formatter1.dateStyle = .short
print(formatter1.string(from: today))
