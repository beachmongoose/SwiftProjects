//
//  ViewController.swift
//  Project25
//
//  Created by Maggie Maldjian on 8/17/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  @IBOutlet var collectionView: UICollectionView!
  var images = [UIImage]()
  var textMessages = [String]()
  var peerID = MCPeerID(displayName: UIDevice.current.name)
  var mcSession: MCSession?
  var mcAdvertiserAssistant: MCAdvertiserAssistant?
  var userList = [String]()
  
  override func viewDidLoad() {
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession?.delegate = self
    
    addNavigationButtons()

    super.viewDidLoad()
  }
}

// MARK: - Image View
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
    if let imageView = cell.viewWithTag(1000) as? UIImageView {
      imageView.image = images[indexPath.item]
    }
    
    return cell
  }
}

// MARK: - Table View
extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return textMessages.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = textMessages[indexPath.row]
    return cell
  }
}

// MARK: - User Input
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    
    dismiss(animated: true)
    images.insert(image, at: 0)
    collectionView.reloadData()
    
    guard let mcSession = mcSession else { return }
    guard mcSession.connectedPeers.count > 0 else { return }
    
    if let imageData = image.pngData() {
      do {
        try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
      } catch {
        let alert = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
        present(alert, animated: true)
      }
    }
  }
  
  @objc func addText() {
    let enterText = UIAlertController(title: "Enter Text", message: nil, preferredStyle: .alert)
    enterText.addTextField()
    enterText.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    let submitText = UIAlertAction(title: "OK", style: .default) { action in
      guard let message = enterText.textFields?[0].text else { return }
      
      self.textMessages.insert(message, at: 0)
      self.tableView.reloadData()
      self.sendText(message)
    }
    enterText.addAction(submitText)
    present(enterText, animated: true)
  }
  
  func sendText(_ text: String) {
    guard let mcSession = mcSession else { return }
    guard mcSession.connectedPeers.count > 0 else { return }
    
    let textMessage = Data(text.utf8)
      do {
        try mcSession.send(textMessage, toPeers: mcSession.connectedPeers, with: .reliable)
      } catch {
        let alert = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
        present(alert, animated: true)
      }
  }
  
}

// MARK: - Connection
extension ViewController {
  @objc func showConnectionPrompt() {
    let connectAlert = UIAlertController(title: "Connect to Others", message: nil, preferredStyle: .alert)
    connectAlert.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
    connectAlert.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
    connectAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
  }
  
  func startHosting(action: UIAlertAction) {
    guard let mcSession = mcSession else { return }
    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
    mcAdvertiserAssistant?.start()
  }
  
  func joinSession(action: UIAlertAction) {
    guard let mcSession = mcSession else { return }
    let mcBrowser = MCBrowserViewController(serviceType: "hsw-project25", session: mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
  }

  @objc func showUsers(_ userList: String) {
    let userAlert = UIAlertController(title: "Users Online", message: userList, preferredStyle: .alert)
    userAlert.addAction(UIAlertAction(title: "OK", style: .default))
    present(userAlert, animated: true)
  }
}

extension ViewController {
  func addNavigationButtons() {
  let pictureButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
  let textButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addText))
  navigationItem.rightBarButtonItems = [textButton, pictureButton]
  let connectionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
    let usersButton = UIBarButtonItem(title: "Users", style: .plain, target: self, action: #selector(getUsers))
    navigationItem.leftBarButtonItems = [connectionButton, usersButton]
  }
  
  @objc func getUsers(action: UIAlertAction) {
    guard let mcSession = mcSession else { return }
    if mcSession.connectedPeers.count > 0 {
      let users = mcSession.connectedPeers
      for user in users {
        userList.append(user.displayName)
      }
      let names = userList.joined(separator: "\n")
      showUsers(names)
    } else {
      let noUserAlert = UIAlertController(title: "There are no current users", message: nil, preferredStyle: .alert)
      noUserAlert.addAction(UIAlertAction(title: "OK", style: .default))
      present(noUserAlert, animated: true)
    }
  }
}

extension ViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case.connected:
      print("Connected: \(peerID.displayName)")
      
    case.connecting:
      print("Connecting: \(peerID.displayName)")
      
    case.notConnected:
      let disconnectAlert = UIAlertController(title: "\(peerID.displayName) has disconnected", message: nil, preferredStyle: .alert)
      disconnectAlert.addAction(UIAlertAction(title: "OK", style: .default))
      present(disconnectAlert, animated: true)
      
    @unknown default:
      print("Unknown state received: \(peerID.displayName)")
    }
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    DispatchQueue.main.async { [weak self] in
      if let image = UIImage(data: data) {
        self?.images.insert(image, at: 0)
        self?.collectionView.reloadData()
      } else {
        let text = String(decoding: data, as: UTF8.self)
        self?.textMessages.insert(text, at: 0)
        self?.tableView.reloadData()
      }
    }
  }
  
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
      dismiss(animated: true)
  }

  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
      dismiss(animated: true)
  }
}

