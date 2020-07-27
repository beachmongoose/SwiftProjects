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
var viewCount = [Int]()

override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .never
    title = "Storm Viewer"
  
  loadImages()
  addViewCount()
  loadViewCount()
}
  
  @objc func loadImages(){
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    for item in items {
        if item.hasPrefix("nssl") {
            pictures.append(item)
            pictures.sort()
        }
    }
  }
  
  func addViewCount(){
    for _ in pictures {
      viewCount.append(0)
    }
  }
  
  func loadViewCount() {
    let defaults = UserDefaults.standard
    
    if let savedData = defaults.object(forKey: "views") as? Data {
      let jsonDecoder = JSONDecoder()
      
      do {
          viewCount = try jsonDecoder.decode([Int].self, from: savedData)
      } catch {
          print("Failed to load view count")
      }
    }
  }
  

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text = pictures[indexPath.row]
    let cellNumber = indexPath.row
    let views = viewCount[cellNumber]
    cell.detailTextLabel!.text = "\(views) views"
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as?
      DetailViewController {
        let numberSelected = indexPath.row
        viewCount[numberSelected] += 1
        save()
        tableView.reloadData()
        detailViewController.selectedImage = pictures[indexPath.row]
        detailViewController.picCount = pictures.count
        detailViewController.picNumber = indexPath.row + 1
        navigationController?.pushViewController(detailViewController, animated: true)
      }
  }
  func save() {
    let jsonEncoder = JSONEncoder()
    if let savedData = try? jsonEncoder.encode(viewCount) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "views")
    } else{
      print("Failed to save data.")
    }
  }
}


