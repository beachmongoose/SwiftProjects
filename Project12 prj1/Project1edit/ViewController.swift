//
//  ViewController.swift
//  Project1edit
//
//  Created by Maggie Maldjian on 7/21/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
var pictures = [String]()

override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .never
    title = "Storm Viewer"
  
  performSelector(inBackground: #selector(loadImages), with: nil)
  
}
  
  @objc func loadImages(){
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    for item in items {
        if item.hasPrefix("nssl") {
            pictures.append(item)
            pictures.sort()
            print(pictures.sorted)
        }
      tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text = pictures[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
        detailViewController.selectedImage = pictures[indexPath.row]
        detailViewController.picCount = pictures.count
        detailViewController.picNumber = indexPath.row + 1
        navigationController?.pushViewController(detailViewController, animated: true)
      }
  }
  
}


