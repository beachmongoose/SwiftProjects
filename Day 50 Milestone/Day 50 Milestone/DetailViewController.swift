//
//  DetailViewController.swift
//  Day 50 Milestone
//
//  Created by Maggie Maldjian on 7/27/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  var cellImage: String?
  var cellLabel: String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      title = cellLabel
    }

}
