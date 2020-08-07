//
//  ActionViewController.swift
//  Extension
//
//  Created by Maggie Maldjian on 8/7/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController, SiteDelegate {
  
  @IBOutlet var script: UITextView!
  @IBOutlet var saveButton: UIButton!
  @IBOutlet var loadButton: UIButton!
  var codeLibrary = [savedCode]()
  
  var pageTitle = ""
  var pageURL = ""
  
    override func viewDidLoad() {
      
      loadSavedCodes()
      
      setUpNavigationButtons()
      
      setUpJavaScriptDictionary()
      
      setUpKeyboardConfiguration()

    }
  
  func bringOver(loadedCode: String) {
    script.text = loadedCode
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "dataTransfer" {
      let vc = segue.destination as! ListViewController
      vc.delegate = self
      vc.codeLibrary = codeLibrary
    }
  }
  
}

// MARK: - Setup
extension ActionViewController {
  
  func setUpNavigationButtons() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
      super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Defaults", style: .plain, target: self, action: #selector(defaultsMenu))
    saveButton.addTarget(self, action: #selector(nameCode), for: .touchUpInside)
//    loadButton.addTarget(self, action: #selector(viewList), for: .touchUpInside)
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
  @objc func nameCode() {
    let code = self.script.text
    
    let saveFunc = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
    saveFunc.addTextField()
    saveFunc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    let submitCode = UIAlertAction(title: "Submit", style: .default) { [weak self, weak saveFunc] action in
      guard let name = saveFunc?.textFields?[0].text else { return }
      if code!.isEmpty && name.isEmpty {
        return
      }
      self!.save(the: name, and: code!)
    }
    saveFunc.addAction(submitCode)
    present(saveFunc, animated: true)
  }
  
  func save(the name: String, and code: String) {
    let newEntry = savedCode(name: name, code: code)
    codeLibrary.append(newEntry)
    let jsonEncoder = JSONEncoder()
    if let savedData = try? jsonEncoder.encode(codeLibrary) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "codeLibrary")
    } else{
      print("Failed to save")
    }
    let saveConfirm = UIAlertController(title: "Code Saved", message: nil, preferredStyle: .alert)
    saveConfirm.addAction(UIAlertAction(title: "OK", style: .default))
    present(saveConfirm, animated: true)
  }
  
  func loadSavedCodes() {
    let defaults = UserDefaults.standard
    
    if let codeData = defaults.object(forKey: "codeLibrary") as? Data {
      let jsonDecoder = JSONDecoder()
      
      do {
          codeLibrary = try jsonDecoder.decode([savedCode].self, from: codeData)
      } catch {
          print("Failed to load")
      }
    }
  }
//  @objc func viewList() {
//    if let listViewController = storyboard?.instantiateViewController(withIdentifier: "Library") as? ListViewController {
//      listViewController.codeLibrary = codeLibrary
//      performSegue(withIdentifier: "dataTransfer", sender: nil)
//      navigationController?.pushViewController(listViewController, animated: true)
//    }
//  }
}
