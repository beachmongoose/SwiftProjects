//
//  DetailViewController.swift
//  Project16
//
//  Created by Maggie Maldjian on 8/5/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {

  @IBOutlet var webView: WKWebView!
  var site: String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        goToWeb(site!)
    }
    
  func goToWeb(_ site: String) {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
    let url = URL(string: "https://en.wikipedia.org/wiki/" + site)!
    webView.load(URLRequest(url: url))
  }
}
