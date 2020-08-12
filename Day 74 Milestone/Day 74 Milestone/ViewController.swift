//
//  ViewController.swift
//  Day 74 Milestone
//
//  Created by Maggie Maldjian on 8/11/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, DataDelegate {
  @IBOutlet var noteTable: UITableView!
  var savedNotes = [noteData]()
  var delegate: DataDelegate?
  var todaysDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return(formatter.string(from: Date()))
  }
  let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(massDelete))
  let confirmButton = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(confirmDelete))
  let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(abort))
  let composeButton = UIBarButtonItem(title: "Compose", style: .plain, target: self, action: #selector(createNewNote))
  
  override func viewDidLoad() {
  
    loadData()
    
    super.viewDidLoad()
    
    navigationButtons()
  
  }

  func bringOver(savedData: [noteData]) {
    savedNotes = savedData
    noteTable.reloadData()
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
  
  @objc func massDelete() {
    noteTable.isEditing = !isEditing
    self.navigationItem.rightBarButtonItem = confirmButton
    self.navigationItem.leftBarButtonItem = cancelButton
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
   if editingStyle == .delete {
    savedNotes.remove(at: indexPath.row)
   }
  }
  
  @objc func confirmDelete() {
    
    let deleteConfirm = UIAlertController(title: "Notes Deleted", message: nil, preferredStyle: .alert)
    deleteConfirm.addAction(UIAlertAction(title: "OK", style: .default))
    present(deleteConfirm, animated: true)
    self.navigationItem.rightBarButtonItem = deleteButton
    
  }
  
  @objc func abort() {
    noteTable.isEditing = false
    self.navigationItem.rightBarButtonItem = deleteButton
    self.navigationItem.leftBarButtonItem = composeButton
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
    cell.cellBody.text = getPreviewLine(for: note)
    cell.cellDate.text = note.date
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
    let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(massDelete))
    self.navigationItem.rightBarButtonItem = deleteButton
    let composeButton = UIBarButtonItem(title: "Compose", style: .plain, target: self, action: #selector(createNewNote))
    self.navigationItem.leftBarButtonItem = composeButton
    let longPressCheck = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
    view.addGestureRecognizer(longPressCheck)
  }
  
  @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
    if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
      let touchPoint = longPressGestureRecognizer.location(in: noteTable)
      if let selectedNote = noteTable.indexPathForRow(at: touchPoint) {
        showOptions(selectedNote.row)
      }
    }
  }
  
  func showOptions(_ noteLocation: Int) {
    let optionsAlert = UIAlertController(title: "Note Selected", message: nil, preferredStyle: .alert)
    optionsAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
      self.savedNotes.remove(at: noteLocation)
      self.save()
      self.noteTable.reloadData()
    }))
    optionsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(optionsAlert, animated: true)
  }
  
  func save() {
    let jsonEncoder = JSONEncoder()
    if let savedData = try? jsonEncoder.encode(savedNotes) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "savedNotes")
    } else {
      print("Failed to save")
    }
  }
  
  func getPreviewLine(for note: noteData) -> String {
    if !note.body.isEmpty {
      let lines = note.body.components(separatedBy: "\n")
      return lines[1]
    } else {
      return ""
    }
  }
}
