//
//  ImageData.swift
//  Day 50 Milestone
//
//  Created by Maggie Maldjian on 7/27/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation
import UIKit

struct ImageData: Codable {
  var imagePath: String
  var name: String
  
//  init(image: String, name: String) {
//    self.image = image
//    self.name = name
//  }
}
extension ImageData {
  var displayImage: UIImage {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let path = paths[0].appendingPathComponent(imagePath)
    return UIImage(contentsOfFile: path.path) ?? UIImage()
  }
}
