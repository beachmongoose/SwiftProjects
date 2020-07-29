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
  var image: UIImage?
  var imageLabel: String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      title = imageLabel
      
      if let image = self.image {
        imageView.image = image
      }
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }
  
}
