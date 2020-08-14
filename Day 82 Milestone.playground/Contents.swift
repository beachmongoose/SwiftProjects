//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
  
  let view = UIView()
  view.bounceOut(3)


extension UIView {
  func bounceOut(_ duration: Double) {
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
      self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
    })
  }
}

extension Int {
  func times(_ closure:() -> ()) -> Void {
    guard self > 0 else { return }
    for _ in 1...self {
      closure()
    }
    return
  }
}
  

5.times( { print("Hello World")})


extension Array where Element: Comparable {
  mutating func remove(item: Element) {
    let spot = (firstIndex(of: item))
    guard spot != nil else { return }
    self.remove(at: spot!)
    return
      }
    }

var testArray = ["who", "what", "where", "what", "when", "why"]

testArray.remove(item: "what")
print(testArray)
