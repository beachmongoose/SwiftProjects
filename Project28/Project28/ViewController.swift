//
//  ViewController.swift
//  Project28
//
//  Created by Maggie Maldjian on 8/21/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
  @IBOutlet var secret: UITextView!
  
  override func viewDidLoad() {
    
    notificationController()
    setPassword()
    
    title = "Nothing to see here"
    
    super.viewDidLoad()
  }
  
}

extension ViewController {
  
  @IBAction func authenticateTapped(_ sender: Any) {
//    unlockSecretMessage()
    let context = LAContext()
    var error: NSError?
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      let reason = "Identify yourself!"
      
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
      [ weak self ] success, authenticationError in
        
        DispatchQueue.main.async {
          if success {
            self?.unlockSecretMessage()
          } else {
            self?.showError(title: "Authentication Failed",
                            message: "You could not be verified; please try again")
          }
        }
      }
    } else {
      self.showError(title: "Biometry Unavailable",
                     message: "Your device is not configured for biometric authentication.")
    }
  }
  
  func unlockSecretMessage() {
    secret.isHidden = false
    toggleDoneButton("show")
    title = "Secret Stuff!"
    
    secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
  }
  @objc func saveSecretMessage() {
    guard secret.isHidden == false else { return }
    
    KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
    secret.resignFirstResponder()
    secret.isHidden = true
    toggleDoneButton("hide")
    title = "Nothing to see here"
  }
}

// MARK: - Keyboard Configuration
extension ViewController {
  
  func notificationController() {
    addObserver(for: UIResponder.keyboardWillHideNotification)
    addObserver(for: UIResponder.keyboardWillChangeFrameNotification)
    addObserver(for: UIApplication.willResignActiveNotification)
  }
  
  func addObserver(for responder: NSNotification.Name) {
  let notifCenter = NotificationCenter.default
    notifCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: responder, object: nil)
  }
  
  @objc func adjustForKeyboard(notif: Notification) {
    guard let keyboardValue = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
    else { saveSecretMessage(); return }
    
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notif.name == UIResponder.keyboardWillHideNotification {
      secret.contentInset = .zero
    } else {
      secret.contentInset =
      UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
    
    secret.scrollIndicatorInsets = secret.contentInset
    
    let selectedRange = secret.selectedRange
    secret.scrollRangeToVisible(selectedRange)
  }
}

extension ViewController {
  func showError (title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    alertController.addAction(UIAlertAction(title: "Password", style: .default, handler: passwordPrompt))
    present(alertController, animated: true)
  }
  
  func toggleDoneButton(_ state: String) {
    if state == "show" {
      let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSecretMessage))
      navigationItem.rightBarButtonItem = button
    } else {
      navigationItem.rightBarButtonItem = nil
    }
  }
  
  func setPassword() {
    KeychainWrapper.standard.set("Password", forKey: "Password")
  }
  
  func passwordPrompt(action: UIAlertAction) {
    let passwordAlert = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
    passwordAlert.addTextField()
    passwordAlert.textFields?[0].isSecureTextEntry = true
    passwordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    passwordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
      guard let text = passwordAlert.textFields?[0].text else { return }
      let password = KeychainWrapper.standard.string(forKey: "Password")
      if text == password {
        self.unlockSecretMessage()
      } else {
        self.showError(title: "Incorrect Password", message: "Does not match password on file.")
      }
    }))
    present(passwordAlert, animated: true)
  }
}
