//
//  Capital.swift
//  Project16
//
//  Created by Maggie Maldjian on 8/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
  var title: String?
  var coordinate: CLLocationCoordinate2D
  var info: String
  
  init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
  self.title = title
  self.coordinate = coordinate
  self.info = info
  }
}
