//
//  ViewController.swift
//  Project7
//
//  Created by Maggie Maldjian on 7/17/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  var petitions: [Petition] = []
  var filteredPetitions: [Petition] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    
    performSelector(inBackground: #selector(fetchJSON), with: nil)
    
  }
}


// UITableViewController Functionality
extension ViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return filteredPetitions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let petition = filteredPetitions[indexPath.row]
    cell.textLabel?.text = petition.title
    cell.detailTextLabel?.text = petition.body
    return cell
  }
  
  override func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let viewController = DetailViewController()
    viewController.detailItem = filteredPetitions[indexPath.row]
    navigationController?.pushViewController(viewController, animated:  true)
  }
}


// View Setup
extension ViewController {
  func setup() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(viewCredits))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchFunction))
    
  }
    
    @objc func fetchJSON() {
    let urlString: String
    
    if navigationController?.tabBarItem.tag == 0 {
        urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    } else {
        urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }
    
      if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
          parse(json: data)
          return
        }
      }
      performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
  }
}

// MARK: - Helpers
extension ViewController {
  func parse(json: Data) {
    let decoder = JSONDecoder()
    
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
      petitions = jsonPetitions.results
      filteredPetitions = petitions
      tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    } else {
      performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    }

  @objc func showError() {
    DispatchQueue.main.async {
      let alertControl = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
      alertControl.addAction(UIAlertAction(title: "OK", style: .default))
      self.present (alertControl, animated: true)
    }
  }
}

// Navigation Bar
extension ViewController {
  @objc func viewCredits() {
    let alertController = UIAlertController (title: "Petitions Source:", message: "We The People API of the Whitehouse", preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "Back", style: .default))
               present (alertController, animated: true)
  }
  
  @objc func searchFunction() {
      let alertController = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
      alertController.addTextField()
      
      let submitAction = UIAlertAction(title: "Submit", style: .default) { [self, alertController] action in
        guard let searchCriteria = alertController.textFields?[0].text else { return }
        self.searchInput(search: searchCriteria)
      }
      alertController.addAction(submitAction)
      present(alertController, animated: true)
    }
  
    func searchInput(search: String) {
      DispatchQueue.global(qos: .userInitiated).async {
        self.filteredPetitions = []
        for petition in self.petitions {
        if petition.contains(search) {
          self.filteredPetitions.append(petition)
        }
      }
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
}

extension Petition {
  func contains(_ searchText: String) -> Bool {
    title.lowercased().contains(searchText.lowercased()) || body.lowercased().contains(searchText.lowercased())
  }
}
