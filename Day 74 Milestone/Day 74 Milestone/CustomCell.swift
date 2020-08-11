//
//  CustomCell.swift
//  Day 74 Milestone
//
//  Created by Maggie Maldjian on 8/11/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
  @IBOutlet var cellTitle: UILabel!
  @IBOutlet var cellDate: UILabel!
  @IBOutlet var cellBody: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

  
  
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
