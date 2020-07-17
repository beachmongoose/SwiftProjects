//
//  ViewController.swift
//  Day 32 Milestone
//
//  Created by Maggie Maldjian on 7/17/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  var listItems = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableSetup()
    addItem()
    tableUpdate()
  }

}
// MARK: - Sets up table cells
extension ViewController{
  
  func tableSetup() {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return listItems.count
    }
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "listCells", for: indexPath)
    cell.textLabel?.text = listItems[indexPath.row]
    return cell
  }
}
// MARK: - Prompt to Add Item
extension ViewController {
  func addItem() {
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToList))
  }
  @objc func addToList() {
      let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
      alertController.addTextField()
      
      let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] action in
        guard let addItem = alertController?.textFields?[0].text else { return }
        self?.submit(addItem)
      }
      alertController.addAction(submitAction)
      present(alertController, animated: true)
    }
  }
// MARK: - Update list with new item
extension ViewController {
  func tableUpdate() {
     func submit(item: String) {
          listItems.insert (item, at: 0)
          let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
    }
  }
}
 

