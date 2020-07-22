//
//  ViewController.swift
//  Day 41 Milestone
//
//  Created by Maggie Maldjian on 7/21/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var hangman: UIImageView!
  @IBOutlet var word: UILabel!
  @IBOutlet var enterLetter: UIButton!
  @IBOutlet var usedLettersLabel: UILabel!
  @IBOutlet var usedLettersBox: UIView!
  
  var chances = 7 {
     didSet{
       title = "Chances Left: \(chances)"
       hangman.image = UIImage(named: "hangman\(chances)")
     }
   }
   
  var answerWord = ""
  var usedLetters = [String]()
  var alphabet = [String]()
  var potentialWords = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addBorder(to: hangman)
    addBorder(to: usedLettersBox)
    enterLetter.addTarget(self, action: #selector(letterBox), for: .touchUpInside)
    title = "Chances Left: \(chances)"
    resetButton()
    
    getAlphabet()
    getWords()
    loadWord()
    checkGameStatus()
  }
}
// MARK: - Get Data
extension ViewController {
  func getAlphabet() {
    if let alphabetURL = Bundle.main.url(forResource: "alphabet", withExtension: "txt") {
      if let alphabetData = try? String(contentsOf: alphabetURL) {
        let letters = alphabetData.components(separatedBy: "/")
        alphabet.append(contentsOf: letters)
        }
      }
    }
  func getWords(){
    if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
      if let wordsData = try? String(contentsOf: wordsURL) {
        potentialWords.append(contentsOf: wordsData.components(separatedBy: "\n"))
        }
      }
    }
  func loadWord() {
    answerWord = potentialWords.randomElement()!
  }
}


extension ViewController {
  func checkGameStatus() {
    var wordHiddenMode = ""
    for letter in answerWord {
      let guessedLetter = String(letter)
      
      if usedLetters.contains(guessedLetter) {
        wordHiddenMode += guessedLetter
      } else {
        wordHiddenMode += "?"
      }
    }
    word.text = wordHiddenMode
    usedLettersLabel.text = usedLetters.joined(separator: ", ")

    if !wordHiddenMode.contains("?") {
      gameWin()
    }
  }
}

// MARK: - User Input
extension ViewController {
  @objc func letterBox() {
      let alertController = UIAlertController(title: "Enter Letter", message: nil, preferredStyle: .alert)
      alertController.addTextField()
      
      let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] action in
        guard let entry = alertController?.textFields?[0].text else { return }
        self!.check(entry)
      }
      alertController.addAction(submitAction)
      present(alertController, animated: true)
    }
  func check(_ letter: String) {
    let enteredLetter = letter.uppercased()
      if oneLetter(enteredLetter) {
        if aLetter(enteredLetter) {
          if newLetter(enteredLetter) {
            usedLetters.append(enteredLetter)
            checkGameStatus()
            if wordDoesntHave(enteredLetter) {
              chances -= 1
            }
            if chances == 0 {
              gameOver()
            }
          } else {
            showErrorMessage("That letter has been guessed already.")
          }
        } else {
          showErrorMessage("That is not a letter.")
        }
      } else {
        showErrorMessage("Invalid Entry")
      }
  }
  func gameOver() {
    let alertController = UIAlertController(title: "Game Over", message: "Try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "New Game", style: .default, handler: reset))
    present(alertController, animated: true)
    }
  func gameWin() {
    let alertController = UIAlertController(title: "You Win", message: "Congratulations!", preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Reset", style: .default, handler: reset))
    present(alertController, animated: true)
  }
  @objc func reset(action:UIAlertAction) {
    usedLetters.removeAll(keepingCapacity: true)
    loadWord()
    checkGameStatus()
    chances = 7
  }
}
  
// MARK: - Check Input
extension ViewController {
  func aLetter (_ entry: String) -> Bool {
    if alphabet.contains(entry) {
      return true
    } else {
      return false
    }
  }
  
  func oneLetter (_ entry: String) -> Bool {
    if entry.count == 1 {
      return true
    } else {
      return false
    }
  }
  func newLetter (_ entry: String) -> Bool {
    if !usedLetters.contains(entry) {
      return true
    } else {
      return false
    }
  }
  func wordDoesntHave (_ entry: String) -> Bool {
    if !answerWord.contains(entry) {
      return true
    } else {
    return false
    }
  }
  func showErrorMessage(_ errorMessage: String) {
    let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
  alertController.addAction(UIAlertAction(title: "OK", style: .default))
  present(alertController, animated: true)
  }
}

extension ViewController {
  func resetButton() {
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
  }
  func addBorder(to box: UIView) {
      box.layer.borderWidth = 1
      box.layer.borderColor = UIColor.black.cgColor
  }
}
