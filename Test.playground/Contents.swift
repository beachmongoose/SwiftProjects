//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
  var string = ""
  var doctorClass = Doctor(name: , salary: 100)
  
  let something = doctorClass.salary
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white


        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        label.text = doctorClass.name
        
        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

final class Doctor {
  var name: String
  var salary: Int
  
  init(name: String, salary: Int) {
    self.name = name
    self.salary = salary
  }
}
