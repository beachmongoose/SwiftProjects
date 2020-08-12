//
//  DetailViewController.swift
//  Day 74 Milestone
//
//  Created by Maggie Maldjian on 8/11/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

protocol DataDelegate {
  func bringOver(savedData: [noteData])
}

class DetailViewController: UIViewController {
  
  @IBOutlet var textField: UITextView!
  var savedNotes = [noteData]()
  var isNewNote: Bool?
  var delegate: DataDelegate?
  var selectedNote: noteData?
  var arrayNumber: Int?
  var todaysDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return(formatter.string(from: Date()))
  }
  
    override func viewDidLoad() {
        title = selectedNote?.title
        textField.text = selectedNote?.body
        navigationButtons()
      
        super.viewDidLoad()

    }

}

// MARK: - Save Note
extension DetailViewController {
  
  @objc func saveNote() {
    guard var selectedNote = selectedNote else { return }
    getTitle()
    selectedNote.body = textField.text
    selectedNote.date = todaysDate
    
    if isNewNote! {
      savedNotes.append(selectedNote)
    } else {
      savedNotes[arrayNumber!] = selectedNote
    }
    
    let jsonEncoder = JSONEncoder()
    if let savedData = try? jsonEncoder.encode(savedNotes) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "savedNotes")
    } else {
      print("Failed to save")
    }
    
    if self.delegate != nil {
      self.delegate?.bringOver(savedData: savedNotes)
    }
    
    let saveConfirm = UIAlertController(title: "Note Saved", message: nil, preferredStyle: .alert)
    saveConfirm.addAction(UIAlertAction(title: "OK", style: .default, handler: backToMain))
    present(saveConfirm, animated: true)

  }
  
  @objc func backToMain(action: UIAlertAction) {
    navigationController?.popViewController(animated: true)
  }
  
  func getTitle() {
    if !textField.text.isEmpty {
      let lines = textField.text.components(separatedBy: "\n")
      selectedNote?.title = lines[0]
    } else {
      selectedNote?.title = ""
    }
  }
  
  @objc func shareNote() {
    
  }
  
//  override func dismiss(_ animated: Bool) {
//
//      super.viewWillDisappear(animated)
//      self.navigationController?.setNavigationBarHidden(false, animated: true)
//  }
}

extension DetailViewController {
  func navigationButtons() {
    let button1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveNote))
    let button2 = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
    navigationItem.setRightBarButtonItems([button1, button2], animated: true)
    
  }
}
