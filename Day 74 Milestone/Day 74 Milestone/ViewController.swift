//
//  ViewController.swift
//  Day 74 Milestone
//
//  Created by Maggie Maldjian on 8/11/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var noteCount: UILabel!
  @IBOutlet var tableView: UITableView!
  var savedNotes = [noteData]()
  var delegate: DataDelegate?
  var todaysDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return(formatter.string(from: Date()))
  }
  
  override func viewDidLoad() {
    loadData()
    navigationButtons()

    super.viewDidLoad()
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
    updateNotesNumber()
    
    tableView.reloadData()
  }
  
}

// MARK: - Table
extension ViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableCell(withIdentifier: "header")
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
    cell.cellBody.lineBreakMode = .byTruncatingTail
    cell.cellDate.text = note.date
    cell.selectionStyle = .none
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "textEntry") as? DetailViewController {
      detailViewController.selectedNote = savedNotes[indexPath.row]
      detailViewController.arrayNumber = indexPath.row
      detailViewController.isNewNote = false
      detailViewController.savedNotes = savedNotes
      detailViewController.delegate = self
      navigationController?.pushViewController(detailViewController, animated: true)
    }
  }
}

// MARK: - Input
extension ViewController: UIGestureRecognizerDelegate {
  func navigationButtons() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Compose", style: .plain, target: self, action: #selector(createNewNote))
    let longPressCheck = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
    view.addGestureRecognizer(longPressCheck)
  }
  
  @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
    if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
      let touchPoint = longPressGestureRecognizer.location(in: tableView)
      if let selectedNote = tableView.indexPathForRow(at: touchPoint) {
        showOptions(selectedNote.row)
      }
    }
  }
  
  func showOptions(_ noteLocation: Int) {
    let optionsAlert = UIAlertController(title: "Note Selected", message: nil, preferredStyle: .alert)
    optionsAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
      self.savedNotes.remove(at: noteLocation)
      self.save()
      self.noteCount.text = "\(self.savedNotes.count) Notes"
      self.tableView.reloadData()
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
  
  func updateNotesNumber() {
    noteCount.text = "\(savedNotes.count) Notes"
  }
}

extension ViewController: DataDelegate {
  func reload() {
    loadData()
  }
}

//extension ViewController {
//
//  let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(massDelete))
//  let composeButton = UIBarButtonItem(title: "Compose", style: .plain, target: self, action: #selector(createNewNote))
//  let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(confirmDelete))
//  let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(abort))
  
//  @objc func massDelete() {
//    isEditing.toggle()
//    self.navigationItem.rightBarButtonItem = doneButton
//    self.navigationItem.leftBarButtonItem = cancelButton
//  }
//
//  @objc func confirmDelete() {
//    if let selectedRows = tableView.indexPathsForSelectedRows {
//      var items = [noteData]()
//      for indexPath in selectedRows {
//        items.append(savedNotes[indexPath.row])
//      }
//      for item in items {
//        if let index = savedNotes.firstIndex(of: item) {
//        savedNotes.remove(at: index)
//        }
//      }
//      tableView.beginUpdates()
//      tableView.deleteRows(at: selectedRows, with: .automatic)
//      tableView.endUpdates()
//    }
//
//    self.navigationItem.rightBarButtonItem = deleteButton
//    self.navigationItem.leftBarButtonItem = composeButton
//    isEditing = false
//  }
//
//  @objc func abort() {
//    isEditing = false
//    self.navigationItem.rightBarButtonItem = deleteButton
//    self.navigationItem.leftBarButtonItem = composeButton
//  }
//}
