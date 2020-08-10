//
//  ViewController.swift
//  Project6a
//
//  Created by Maggie Maldjian on 7/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
  
  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!
  var countries = [String]()
  var score = 0
  var pastScores = [Int]()
  var correctAnswer = 0
  var round = 0
  func newGame(action: UIAlertAction!) {
    score = 0
    round = 0
    askQuestion(action: nil)
  }
  
  override func viewDidLoad() {
    
    loadPastScores()
    
    super.viewDidLoad()
    
    addNavButtons()
    
    addFlagButtons()

    askQuestion(action: nil)
  }
}
  
extension ViewController {

@objc func viewScore() {
    let alertController = UIAlertController (title: "Current Score", message: "\(score)", preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Back", style: .default))
             present (alertController, animated: true) }

  func askQuestion(action: UIAlertAction!) {
    UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
      self.button1.transform = .identity
      self.button2.transform = .identity
      self.button3.transform = .identity
    })
  countries.shuffle()
  correctAnswer = Int.random(in: 0...2)

  button1.setImage(UIImage(named: countries[0]), for: .normal)
  button2.setImage(UIImage(named: countries[1]), for: .normal)
  button3.setImage(UIImage(named: countries[2]), for: .normal)
  
  let topCountry = countries[correctAnswer].uppercased()
  self.title = "\(topCountry)"
  }
}

extension ViewController {
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.8, options: [], animations: {
    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
  })
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
    else if round == 10 && isNewHighScore() || pastScores.isEmpty {
      endGame(with: "New High Score!")
    } else {
      endGame(with: "Correct")
    }
   }
  }

extension ViewController {

// MARK: - Game Ends
  func endGame(with scoreConfirm: String) {
    let finalAlert = UIAlertController (title: scoreConfirm, message: "Final Score: \(score)",
      preferredStyle: .alert)
    finalAlert.addAction(UIAlertAction(title: "New Game", style: .default, handler: { action in
      self.pastScores.append(self.score)
      self.newGame(action: nil)
      self.scoreSave()
      }))
      present (finalAlert, animated: true)
  }
  
  func isNewHighScore() -> Bool {
    for oldScore in pastScores {
      if oldScore > score {
      return false
      }
    }
    return true
  }
  
  func scoreSave() {
    let jsonEncoder = JSONEncoder()
    if let savedData = try? jsonEncoder.encode(pastScores) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "scores")
      print("Score Saved")
    } else {
      print("No saved scores")
    }
  }
}

// MARK: - Interface
extension ViewController {
  func addFlagButtons() {
    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
       
       button1.layer.borderWidth = 1
       button2.layer.borderWidth = 1
       button3.layer.borderWidth = 1
       
       button1.layer.borderColor = UIColor.lightGray.cgColor
       button2.layer.borderColor = UIColor.lightGray.cgColor
       button3.layer.borderColor = UIColor.lightGray.cgColor
  }
  
  func loadPastScores() {
    let defaults = UserDefaults.standard
    
    if let savedScores = defaults.object(forKey: "scores") as? Data {
      let jsonDecoder = JSONDecoder()
      
      do {
          pastScores = try jsonDecoder.decode([Int].self, from: savedScores)
        print("Loaded Scores")
      } catch {
          print("Failed to load scores")
      }
    }
  }
  
  func addNavButtons() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(viewScore))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Alerts", style: .plain, target: self, action: #selector(alertCenter))
  }
}

// MARK: - App Alerts
extension ViewController {
  @objc func alertCenter() {
    let alertCenter = UIAlertController(title: "App Alerts", message: "Would you like to receive daily reminders about this app?", preferredStyle: .alert)
    alertCenter.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
      let center = UNUserNotificationCenter.current()
      center.removeAllPendingNotificationRequests()
      print("alerts deleted")
      }))
    alertCenter.addAction(UIAlertAction(title: "Yes", style: .default, handler: requestAccess))
    present(alertCenter, animated: true)
  }
  
  @objc func requestAccess(action: UIAlertAction) {
    let center = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
      if granted {
        self.setUpAlerts()
      } else {
      }
    }
  }
  
  func setUpAlerts() {
    let center = UNUserNotificationCenter.current()
    
    setUpUserOptions()
    
    center.removeAllPendingNotificationRequests()
  
    for n in 0...6 {
      setAlarmFor(n)
      print("alerts set up")
    }

  }
  
  func setAlarmFor(_ day: Int) {
    let center = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = "Guess the Flag"
    content.body = "Are you ready to play?"
    content.categoryIdentifier = "alert"
    content.sound = UNNotificationSound.default
  
//    let date = DateComponents(hour: 15, minute: 0, weekday: day)
    let date = DateComponents(hour: 15, minute: 0, weekday: day)
    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
  }
  
  func setUpUserOptions() {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
//    let open = UNNotificationAction(identifier: "open", title: "Open", options: .foreground)
    let stop = UNNotificationAction(identifier: "stop", title: "Turn off alerts", options: .destructive)
    let category = UNNotificationCategory(identifier: "alert", actions: [stop], intentIdentifiers: [])
    
    center.setNotificationCategories([category])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler finishProcess: @escaping () -> Void) {
    switch response.actionIdentifier {
    case UNNotificationDefaultActionIdentifier:
      showMessage(title: "Welcome back", message: "Press OK to start.")
      let center = UNUserNotificationCenter.current()
      center.removeAllPendingNotificationRequests()
      setUpAlerts()
      
    case "stop":
      let center = UNUserNotificationCenter.current()
      
      center.removeAllPendingNotificationRequests()
      print("alerts deleted")
    default:
      break
    }
    finishProcess()
  }
  
  func showMessage (title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(alertController, animated: true)
  }
}


