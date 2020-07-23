//
//  Person.swift
//  Project10
//
//  Created by Maggie Maldjian on 7/23/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class Person: NSObject {
  var name: String
  var image: String
  init(name: String, image: String) {
    self.name = name
    self.image = image
  }
}
