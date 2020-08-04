//
//  ViewController.swift
//  Day 59 Milestone
//
//  Created by Maggie Maldjian on 8/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet var tableView: UITableView!
  var countries: [Country] = []
  var allFacts: [String]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Country Database"
    loadTableData()
    getFacts()
  }
// MARK: - Table Setup
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countries.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let country = countries[indexPath.row]
    cell.textLabel?.text = country.name
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailViewController = DetailViewController()
    detailViewController.selectedItem = countries[indexPath.row]
    detailViewController.selectedFacts = allFacts?[indexPath.row]
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}

// MARK: - Get Data
extension ViewController {
  func loadTableData(){
    
    if let countriesFile = Bundle.main.url(forResource: "countries", withExtension: "json") {
      if let data = try? Data(contentsOf: countriesFile) {
      parse(data)
      }
    }
  }
  
  func parse(_ json: Data) {
      if let data = try? JSONDecoder().decode(Countries.self, from: json) {
        countries = data.countries
        tableView.reloadData()
      } else {
        print("nope")
    }
  }
}

extension ViewController {
  func getFacts(){
    if let funFactsURL = Bundle.main.url(forResource: "Fun Facts", withExtension: "txt") {
      if let funFactsFile = try? String(contentsOf: funFactsURL) {
        allFacts = funFactsFile.components(separatedBy: "\n")
      }
    }
  }
}
