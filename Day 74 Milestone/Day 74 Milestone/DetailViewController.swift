//
//  DetailViewController.swift
//  Day 74 Milestone
//
//  Created by Maggie Maldjian on 8/11/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet var textField: UITextView!
  var savedNotes = [noteData]()
  var isNewNote = false
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
    guard var currentNote = selectedNote else { return }
    currentNote.title = getTitle()
    currentNote.body = textField.text
    currentNote.date = todaysDate
    
    if isNewNote {
      savedNotes.append(currentNote)
    } else {
    guard let arrayNumber = arrayNumber else { return }
      savedNotes[arrayNumber] = currentNote
    }
    
    let jsonEncoder = JSONEncoder()
    if let savedData = try? jsonEncoder.encode(savedNotes) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "savedNotes")
    } else {
      print("Failed to save")
    }
    
    let saveConfirm = UIAlertController(title: "Note Saved", message: nil, preferredStyle: .alert)
    saveConfirm.addAction(UIAlertAction(title: "OK", style: .default, handler: backToMain))
    present(saveConfirm, animated: true)

  }
  
  @objc func backToMain(action: UIAlertAction) {
    navigationController?.popViewController(animated: true)
  }
  
  func getTitle() -> String {
    if !textField.text.isEmpty {
      let lines = textField.text.components(separatedBy: "\n")
      return lines[0]
    } else {
      return ""
    }
  }
  
  @objc func shareNote() {
    guard let note = selectedNote?.body else { return }
    let viewController = UIActivityViewController(activityItems: [note], applicationActivities: [])
    viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present (viewController, animated: true)
  }
}

// MARK: - Setup
extension DetailViewController {
  func navigationButtons() {
    let button1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveNote))
    let button2 = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
    navigationItem.setRightBarButtonItems([button1, button2], animated: true)
  }

  func setUpKeyboardConfiguration() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }
  
  @objc func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      textField.contentInset = .zero
      } else {
      textField.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
    
    textField.scrollIndicatorInsets = textField.contentInset
    
    let selectedRange = textField.selectedRange
    textField.scrollRangeToVisible(selectedRange)
  }
}
