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
  var url: String
  
  init(title: String, coordinate: CLLocationCoordinate2D, url: String) {
  self.title = title
  self.coordinate = coordinate
  self.url = url
  }
}
