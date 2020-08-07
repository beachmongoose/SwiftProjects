//
//  ListViewController.swift
//  Extension
//
//  Created by Maggie Maldjian on 8/7/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

protocol SiteDelegate {
  func bringOver(loadedCode: String)
}

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet var tableView: UITableView!
  var codeLibrary = [savedCode]()
  var delegate: SiteDelegate?
  
    override func viewDidLoad() {
      title = "Saved Codes"
        super.viewDidLoad()

    }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return codeLibrary.count }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let selectedCode = codeLibrary[indexPath.row]
    cell.textLabel?.text = selectedCode.name
      return cell
  }
  
}

extension ListViewController {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selected = codeLibrary[indexPath.row]
    if delegate != nil {
      delegate?.bringOver(loadedCode: selected.code)
      self.navigationController?.popViewController(animated: true)
    }
  }
}

