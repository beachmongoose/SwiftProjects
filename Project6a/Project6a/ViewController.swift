//
//  ViewController.swift
//  Project6a
//
//  Created by Maggie Maldjian on 7/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!

var countries = [String]()
  var score = 0
  var correctAnswer = 0
  var round = 0
  func newGame(action: UIAlertAction!) {
    score = 0
    round = 0 }
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(viewScore))
    
 countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    
    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1
    
    button1.layer.borderColor = UIColor.lightGray.cgColor
    button2.layer.borderColor = UIColor.lightGray.cgColor
    button3.layer.borderColor = UIColor.lightGray.cgColor
    askQuestion(action: nil)
    }

@objc func viewScore() {
    let alertController = UIAlertController (title: "Current Score", message: "\(score)", preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Back", style: .default))
             present (alertController, animated: true) }

func askQuestion(action: UIAlertAction!) {
  countries.shuffle()
  correctAnswer = Int.random(in: 0...2)

  button1.setImage(UIImage(named: countries[0]), for: .normal)
  button2.setImage(UIImage(named: countries[1]), for: .normal)
  button3.setImage(UIImage(named: countries[2]), for: .normal)
  
  let topCountry = countries[correctAnswer].uppercased()
  self.title = "\(topCountry)"
  }

  @IBAction func buttonTapped(_ sender: UIButton) {
  var title: String
  let selection = countries[sender.tag].uppercased()
    if sender.tag == correctAnswer {
      title = "Correct"
      score += 1 }
    else if sender.tag != correctAnswer && score == 0{
      title = "Wrong! That's the flag of \(selection)."}
    else {
      title = "Wrong! That's the flag of \(selection)."
      score -= 1 }
  round += 1
  
  if round < 10 {
  let alertController = UIAlertController (title: title, message: "Your score is \(score).", preferredStyle: .alert)
  alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
    present (alertController, animated: true) }
    else {
     let finalAlert = UIAlertController (title: title, message: "Final Score: \(score)",
      preferredStyle: .alert)
    finalAlert.addAction(UIAlertAction(title: "New Game", style: .default, handler: askQuestion))
     present (finalAlert, animated: true)
    newGame(action: nil)
  }
 }
}


