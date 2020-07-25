//
//  ViewController.swift
//  Project5
//
//  Created by Maggie Maldjian on 7/15/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  var allWords = [String]()
  var usedWords = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // MARK: - Set up Game
    gameSetup()
  
    
  }
  
    // MARK: - Set up Answer Input Field
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usedWords.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
    cell.textLabel?.text = usedWords[indexPath.row]
    return cell
  }
  @objc func promptForAnswer() {
    let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
    alertController.addTextField()
    
    let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] action in
      guard let answer = alertController?.textFields?[0].text else { return }
      self?.submit(answer)
    }
    alertController.addAction(submitAction)
    present(alertController, animated: true)
  }
  // MARK: - Check answer validity
  func submit(_ answer: String){
    let lowerAnswer = answer.lowercased()
    
    guard isPossible(word: lowerAnswer) == true else {
      showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title ?? "That word")")
      return
    }
    guard isOriginal(word: lowerAnswer) == true else {
      showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
      return
    }
    guard isReal(word: lowerAnswer) == true else {
      showErrorMessage(errorTitle: "World not recognized", errorMessage: "You can't just make them up, you know!")
      return
    }
    guard isWord(word: lowerAnswer) == true else { showErrorMessage(errorTitle: "Root Word", errorMessage: "That's the word you were given!")
      return
    }
    guard isMoreThanThree(word: lowerAnswer) == true else { showErrorMessage(errorTitle: "Too Small", errorMessage: "Try to think bigger.")
      return
    }
          usedWords.insert (answer, at: 0)
          
          let indexPath = IndexPath(row: 0, section: 0)
          tableView.insertRows(at: [indexPath], with: .automatic)
          saveData(with: title!, as: "rootWord")
          saveData(with: usedWords, as: "usedWords")
          return
  }
  func showErrorMessage (errorTitle: String, errorMessage: String) {
    let alertController = UIAlertController(title: errorTitle,message: errorMessage, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(alertController, animated: true)
  }
  func isPossible(word: String) -> Bool {
    guard var tempWord = title?.lowercased() else { return false }
    
    for letter in word {
      if let position = tempWord.firstIndex(of: letter){
        tempWord.remove(at:position)
      } else {
        return false
      }
    }
    return true
  }
  func isOriginal(word: String) -> Bool {
    return !usedWords.contains(word) && !usedWords.contains(word.uppercased()) && !usedWords.contains(word.capitalized)
  }
  func isReal (word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    return misspelledRange.location == NSNotFound
  }
  func isWord (word: String) -> Bool {
    guard let tempWord = title?.lowercased() else {return false}
    if word.lowercased() == tempWord {
      return false
      }
    return true
  }
  func isMoreThanThree(word: String) -> Bool {
    if word.count > 3 {
      return true
    }
    return false
  }
}
private extension ViewController {
  func gameSetup(){
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(startGame))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
      if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
        if let startWords = try? String(contentsOf: startWordsURL){
        allWords = startWords.components(separatedBy: "\n")
        }
      }
    if allWords.isEmpty {
      allWords = ["silkworm"]
    }
    startGame()
  }
  
  @objc func startGame() {
    title = allWords.randomElement()
    usedWords.removeAll(keepingCapacity: true)
    tableView.reloadData()
  }
  func saveData(with dataToSave: Any, as key: String) {
    let jsonEncoder = JSONEncoder()
    if let savedData = try? jsonEncoder.encode(dataToSave) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: key)
    }
  }
  func loadData(with dataToLoad: Any, as key: String) {
    let defaults = UserDefaults.standard
    
    if let savedData = defaults.object(forKey: "\(key)") as? Data {
      let jsonDecoder = JSONDecoder()
      
      do {
        dataToLoad = try jsonDecoder.decode([Any].self, from: savedData)
      } catch {
        print("Failed to load")
      }
    }
  }
}
