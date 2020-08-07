//
//  ListViewController.swift
//  Extension
//
//  Created by Maggie Maldjian on 8/7/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet var tableView: UITableView!
  var siteCodes = [websiteCode]()
  
    override func viewDidLoad() {
      title = "Saved Codes"
        super.viewDidLoad()

    }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return siteCodes.count }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let selectedCode = siteCodes[indexPath.row]
    cell.textLabel?.text = selectedCode.url
      return cell
  }
  
}
