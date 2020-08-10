//
//  ActionViewController.swift
//  Extension
//
//  Created by Maggie Maldjian on 8/7/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController{
  @IBOutlet var script: UITextView!
  @IBOutlet var saveButton: UIButton!
  @IBOutlet var loadButton: UIButton!
  var siteCodes = [websiteCode]()

  var pageTitle = ""
  var pageURL = ""
  
    override func viewDidLoad() {
      
      script.text = "Enter Code Here"
      
      loadSavedCodes()
      
      setUpNavigationButtons()
      
      setUpJavaScriptDictionary()
      
      setUpKeyboardConfiguration()

      
    }
}

// MARK: - Setup
extension ActionViewController {
  
  func setUpNavigationButtons() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
      super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Defaults", style: .plain, target: self, action: #selector(defaultsMenu))
    saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    loadButton.addTarget(self, action: #selector(viewList), for: .touchUpInside)
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
      script.contentInset = .zero
      } else {
      script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
    
    script.scrollIndicatorInsets = script.contentInset
    
    let selectedRange = script.selectedRange
    script.scrollRangeToVisible(selectedRange)
  }
  
  func setUpJavaScriptDictionary() {
    if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
      if let itemProvider = inputItem.attachments?.first {
        itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
          guard let itemDictionary = dict as? NSDictionary else { return }
          guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
          self?.pageTitle = javaScriptValues["title"] as? String ?? ""
          self?.pageURL = javaScriptValues["URL"] as? String ?? ""

          self!.urlCheck(self!.pageURL)
          
          DispatchQueue.main.async {
            self?.title = self?.pageTitle
          }
        }
      }
    }
  }
}

// MARK: - Input
extension ActionViewController {
  
    @IBAction func done() {
      let item = NSExtensionItem()
      let argument: NSDictionary = ["customJavaScript": script.text!]
      let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
      let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
      item.attachments = [customJavaScript]
      
      extensionContext?.completeRequest(returningItems: [item])
    }

  @objc func defaultsMenu() {
    let defaultsList = UIAlertController(title: "Select Default Code", message: nil, preferredStyle: .alert)
    defaultsList.addAction(UIAlertAction(title: "Alert", style: .default, handler: { action in
      self.changeScriptText(to: "alert(document.title);")
    }))
    defaultsList.addAction(UIAlertAction(title: "Test", style: .default, handler: { action in
      self.changeScriptText(to: "Test")
    }))
    defaultsList.addAction(UIAlertAction(title: "Test2", style: .default, handler: { action in
      self.changeScriptText(to: "Test2")
    }))
    defaultsList.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(defaultsList, animated: true)
  }
  func changeScriptText(to selectedDefault: String) {
  self.script.text = selectedDefault
  }
}

extension ActionViewController {
  
  @objc func save() {
    let newEntry = websiteCode(url: self.pageURL, code: self.script.text)
    siteCodes.append(newEntry)
    let jsonEncoder = JSONEncoder()
    if let savedData = try? jsonEncoder.encode(siteCodes) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "siteCodes")
    } else{
      print("Failed to save")
    }
    let saveConfirm = UIAlertController(title: "Code Saved", message: nil, preferredStyle: .alert)
    saveConfirm.addAction(UIAlertAction(title: "OK", style: .default))
    present(saveConfirm, animated: true)
  }
  
  func loadSavedCodes() {
    let defaults = UserDefaults.standard
    
    if let codeData = defaults.object(forKey: "siteCodes") as? Data {
      let jsonDecoder = JSONDecoder()
      
      do {
          siteCodes = try jsonDecoder.decode([websiteCode].self, from: codeData)
      } catch {
          print("Failed to load")
      }
    }
  }
  
  func urlCheck(_ address: String) {
    for entry in siteCodes {
      if entry.url.contains(address) {
        self.script.text = entry.code
        done()
          } else {
          return
        }
      }
    }
  
  @objc func viewList() {
    if let listViewController = storyboard?.instantiateViewController(withIdentifier: "Library") as? ListViewController {
        listViewController.siteCodes = siteCodes
        navigationController?.pushViewController(listViewController, animated: true)
    }
  }
}
