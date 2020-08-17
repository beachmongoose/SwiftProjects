//
//  ViewController.swift
//  Project25
//
//  Created by Maggie Maldjian on 8/17/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case.connected:
      print("Connected: \(peerID.displayName)")
      
    case.connecting:
      print("Connecting: \(peerID.displayName)")
      
    case.notConnected:
      print("Not Connected: \(peerID.displayName)")
      
    @unknown default:
      print("Unknown state received: \(peerID.displayName)")
      
    }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    DispatchQueue.main.async { [weak self] in
      if let image = UIImage(data: data) {
        self?.images.insert(image, at: 0)
        self?.collectionView.reloadData()
      }
    }
  }
  
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    <#code#>
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    <#code#>
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    <#code#>
  }
  
var images = [UIImage]()
  var peerID = MCPeerID(displayName: UIDevice.current.name)
  var mcSession: MCSession?
  var mcAdvertiserAssistant: MCAdvertiserAssistant?
  
  
  override func viewDidLoad() {
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession?.delegate = self
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
    super.viewDidLoad()
  }
}

extension ViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
    if let imageView = cell.viewWithTag(1000) as? UIImageView {
      imageView.image = images[indexPath.item]
    }
    
    return cell
  }
}

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
  
}

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
}

