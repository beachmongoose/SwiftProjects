//
//  DetailViewController.swift
//  Day 59 Milestone
//
//  Created by Maggie Maldjian on 8/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
var webView: WKWebView!
var selectedItem: Country?
var selectedFacts: String?
var funFacts: [String]?
  
  override func loadView() {
    webView = WKWebView()
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    formatFacts()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fun Facts", style: .plain, target: self, action: #selector(showFact))
    
    guard let selectedItem = selectedItem else { return}
    title = selectedItem.name
    let html = """
    <html>
    <head>
    <meta name ="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body>
    <p style="font-family:helvetica;">
    \(selectedItem.details)
    </p>
    </body>
    </html>
    """

    webView.loadHTMLString(html, baseURL: nil)
  }
}
  
extension DetailViewController {
  func formatFacts(){
    guard let selectedFacts = selectedFacts else { return }
    var array = selectedFacts.components(separatedBy: ": ")
    array.remove(at: 0)
    self.funFacts = array
  }
  @objc func showFact() {
    let factPopUp = UIAlertController(title: "Fun Fact", message: "\(funFacts!.randomElement() ?? "Error")", preferredStyle: .alert)
    factPopUp.addAction(UIAlertAction(title: "OK", style: .default))
    present (factPopUp, animated: true)
  }

}
