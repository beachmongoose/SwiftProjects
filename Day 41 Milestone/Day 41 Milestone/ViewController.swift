//
//  ViewController.swift
//  Day 41 Milestone
//
//  Created by Maggie Maldjian on 7/21/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
var score = 0
@IBOutlet var hangman: UIImageView!
@IBOutlet var alphabetBox: UIView!
@IBOutlet var wordToGuess: UILabel!
@IBOutlet var usedLettersBox: UIView!
var hintForAnswerWord: UILabel!
var answerWord: UILabel!
var usedLetters = [String]()
var guessedLetters = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addBorder(to: alphabetBox)
    addBorder(to: hangman)
  }
  func addBorder(to box: UIView) {
      box.layer.borderWidth = 1
      box.layer.borderColor = UIColor.black.cgColor
  }

}
extension ViewController {
  func getWordsAndHints(){
    if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
      if let wordsData = try? String(contentsOf: wordsURL) {
        var answersAndHints = wordsData.components(separatedBy: "\n")
        answersAndHints.shuffle()
        for instances in answersAndHints {
          let parts = instances.components(separatedBy: ": ")
          let hintWords = parts [1]
          let answerWords = parts [0]
          var hint = hintWords [0]
          var answer = answerWords [0]
        }
      }
    }
  }
}
extension StringProtocol {
  subscript(offset: Int) -> Character {
          self[index(startIndex, offsetBy: offset)]
      }
  }
