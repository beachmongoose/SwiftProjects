//
//  ViewController.swift
//  Project8
//
//  Created by Maggie Maldjian on 7/20/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var cluesLabel: UILabel!
  var answersLabel: UILabel!
  var currentAnswer: UITextField!
  var scoreLabel: UILabel!
  var letterButtons = [UIButton]()
  
  var activatedButtons = [UIButton]()
  var solutions = [String]()
  
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  var level = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadLevel()
  }
}

// MARK: - Button Actions
extension ViewController {
   @objc func letterTapped (_ sender: UIButton) {
      guard let buttonTitle = sender.titleLabel?.text else { return }
      UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
         sender.alpha = 0
      })
      currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
      activatedButtons.append(sender)
  }
  
  @objc func submitTapped(_ sender: UIButton) {
    guard let answerText = currentAnswer.text else { return }
    
    if let solutionPosition = solutions.firstIndex(of: answerText) {
      activatedButtons.removeAll()
      
      var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
      splitAnswers?[solutionPosition] = answerText
      answersLabel.text = splitAnswers?.joined(separator: "\n")
      
      currentAnswer.text = ""
      score += 1
      scoreCheck()
    }
    else {
      if score >= 1 {
        score -= 1
      }
      wrongAnswerAlert()
    }
  }
  
  @objc func clearTapped(_ sender: UIButton) {
    currentAnswer.text = ""
      for button in activatedButtons {
         UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            button.alpha = 1
         })
      }
      activatedButtons.removeAll()
  }
}

// MARK: - Word Submit
extension ViewController {
  func wrongAnswerAlert() {
    let alertController = UIAlertController(title: "Wrong Answer", message: "Try again.", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(alertController, animated: true)
  }
  
  func scoreCheck() {
    var allButtonsAreHidden = true
    for button in letterButtons {
      if button.alpha == 1 {
        allButtonsAreHidden = false
      }
    }
    if allButtonsAreHidden && activatedButtons.count == 0 {
      levelComplete()
    }
  }
}

// MARK: - Level Up
extension ViewController {
  func levelComplete() {
    let alertController = UIAlertController(title: "Well Done!", message: "Your score is \(score).\nAre you ready for the next level?", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
    present(alertController, animated: true)
  }
  
  func levelUp(action:UIAlertAction) {
    level += 1
    solutions.removeAll(keepingCapacity: true)
    
    loadLevel()
    
    for button in letterButtons {
      UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
         button.alpha = 1
      })
    }
  }
}
// MARK: - Level Load
extension ViewController {
  func loadLevel () {
    var clueString = ""
    var solutionString = ""
    var letterBits = [String]()
   DispatchQueue.global(qos: .userInitiated).async {
      if let levelFileURL = Bundle.main.url(forResource: "level\(self.level)", withExtension: "txt") {
      if let levelContents = try? String(contentsOf: levelFileURL) {
        var lines = levelContents.components(separatedBy: "\n")
        lines.shuffle()
        
        for (index, line) in lines.enumerated() {
          let parts = line.components(separatedBy: ": ")
          let answer = parts [0]
          let clue = parts [1]
          
          clueString += "\(index + 1). \(clue)\n"
          
          let solutionWord = answer.replacingOccurrences(of: "|", with: "")
          solutionString += "\(solutionWord.count) letters\n"
         self.solutions.append(solutionWord)
          
          let bits = answer.components(separatedBy: "|")
          letterBits += bits
        }
      }
      }
    }
   DispatchQueue.main.async {
      self.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
      self.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
    
    letterBits.shuffle()
    
      if letterBits.count == self.letterButtons.count {
         for i in 0 ..< self.letterButtons.count {
            self.letterButtons[i].setTitle(letterBits[i], for: .normal)
      }
    }
  }
}
}
// MARK: - Layout
extension ViewController {
  override func loadView() {
    view = UIView()
    view.backgroundColor = .white
    
    scoreLabel = UILabel()
    scoreLabel.translatesAutoresizingMaskIntoConstraints = false
    scoreLabel.textAlignment = .right
    scoreLabel.text = "Score: 0"
    view.addSubview(scoreLabel)
    
    cluesLabel = UILabel()
    cluesLabel.translatesAutoresizingMaskIntoConstraints = false
    cluesLabel.font = UIFont.systemFont(ofSize: 24)
    cluesLabel.text = "CLUES"
    cluesLabel.numberOfLines = 0
    view.addSubview(cluesLabel)
    
    answersLabel = UILabel()
    answersLabel.translatesAutoresizingMaskIntoConstraints = false
    answersLabel.font = UIFont.systemFont(ofSize: 24)
    answersLabel.text = "ANSWERS"
    answersLabel.numberOfLines = 0
    answersLabel.textAlignment = .right
    view.addSubview(answersLabel)
    
    cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    
    currentAnswer = UITextField()
    currentAnswer.translatesAutoresizingMaskIntoConstraints = false
    currentAnswer.placeholder = "Tap letters to guess"
    currentAnswer.textAlignment = .center
    currentAnswer.font = UIFont.systemFont(ofSize: 44)
    currentAnswer.isUserInteractionEnabled = false
    view.addSubview(currentAnswer)

    //MARK: - Middle Buttons
    let submit = UIButton(type: .system)
    submit.translatesAutoresizingMaskIntoConstraints = false
    submit.setTitle("SUBMIT", for: .normal)
    view.addSubview(submit)
    submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    
    let clear = UIButton(type: .system)
    clear.translatesAutoresizingMaskIntoConstraints = false
    clear.setTitle("CLEAR", for: .normal)
    view.addSubview(clear)
    clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    
    let buttonsView = UIView()
    buttonsView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(buttonsView)
    buttonsView.layer.borderWidth = 1
    buttonsView.layer.borderColor = UIColor.lightGray.cgColor
    
    // MARK: - Positioning
    NSLayoutConstraint.activate([
      scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
      cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
      answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
      answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
      answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
      currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
      submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
      submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
      submit.heightAnchor.constraint(equalToConstant: 44),
      clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
      clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
      clear.heightAnchor.constraint(equalToConstant: 44),
      buttonsView.widthAnchor.constraint(equalToConstant: 750),
      buttonsView.heightAnchor.constraint(equalToConstant: 320),
      buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
      buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
    ])
    
    // MARK: - Bottom Buttons
    let width = 150
    let height = 80
    
    for row in 0..<4 {
      for col in 0..<5 {
        
        let letterButton = UIButton(type: .system)
        letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        
        letterButton.setTitle("WWW", for: .normal)
        let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
        letterButton.frame = frame
        buttonsView.addSubview(letterButton)
        letterButtons.append(letterButton)
        letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
      }
    }
    
  }
}

