//
//  ViewController.swift
//  Day 74 Milestone
//
//  Created by Maggie Maldjian on 8/11/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, DataDelegate {

  var savedNotes = [noteData]()
  var delegate: DataDelegate?
  var todaysDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return(formatter.string(from: Date()))
  }
  
  override func viewDidLoad() {
  
    loadData()
    
    super.viewDidLoad()
    
    navigationButtons()
  
  }

  func bringOver(savedData: [noteData]) {
    savedNotes = savedData
  }

}

// MARK: - Data
extension ViewController {
  
  @objc func createNewNote() {
      if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "textEntry") as? DetailViewController {
        let newNote = noteData(title: "", body: "Enter text", date: todaysDate)
        detailViewController.selectedNote = newNote
        detailViewController.isNewNote = true
        detailViewController.savedNotes = savedNotes
        navigationController?.pushViewController(detailViewController, animated: true)
      }
  }
  
  @objc func deleteButton() {
    // haven't coded yet
  }
  
  
  func loadData() {
    let defaults = UserDefaults.standard
    if let notesData = defaults.object(forKey: "savedNotes") as? Data {
      let jsonDecoder = JSONDecoder()
      
      do {
        savedNotes = try jsonDecoder.decode([noteData].self, from: notesData)
      } catch {
        print("Failed to load")
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "sendData" {
      let vc = segue.destination as! DetailViewController
      vc.delegate = self
      vc.savedNotes = savedNotes
    }
  }
}

// MARK: - Table
extension ViewController {

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
    return header
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75.0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return savedNotes.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell else {
    fatalError("Unable to Dequeue")
    }
    
    let note = savedNotes[indexPath.row]
    cell.cellTitle.text = note.title
    cell.cellDate.text = note.date
    cell.cellBody.text = note.body
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "textEntry") as? DetailViewController {
      detailViewController.selectedNote = savedNotes[indexPath.row]
      detailViewController.arrayNumber = indexPath.row
      detailViewController.isNewNote = false
      detailViewController.savedNotes = savedNotes
      navigationController?.pushViewController(detailViewController, animated: true)
    }
  }
}

// MARK: - Input
extension ViewController {
  func navigationButtons() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButton))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Compose", style: .plain, target: self, action: #selector(createNewNote))
    let longPressCheck = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
    view.addGestureRecognizer(longPressCheck)
  }
  
  @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
    if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
      let touchPoint = longPressGestureRecognizer.location(in: self.view)
      if let selectedNote = tableView.indexPathForRow(at: touchPoint) {
        showOptions(selectedNote)
      }
    }
  }
  
  func showOptions(_ noteLocation: Int) {
    let optionsAlert = UIAlertController(title: "Note Selected", message: nil, preferredStyle: .alert)
    optionsAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
      self.savedNotes.remove(at: noteLocation)
    }))
    optionsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
  }
  
}
