import UIKit

let defaults = UserDefaults.standard
defaults.set(25,            forKey: "Age")
defaults.set(true,          forKey: "UseTouchID")
defaults.set(CGFloat.pi,    forKey: "Pi")
defaults.set("Paul Hudson", forKey: "Name")
defaults.set(Date(),        forKey: "LastRun")

let array = ["Hello", "World"]
defaults.set(array, forKey: "SavedArray")

let dict = ["Name": "Paul", "Country": "UK"]
defaults.set(dict, forKey: "SavedDict")

let something = defaults.object(forKey:"SavedArray") as? [String]
print(something)
