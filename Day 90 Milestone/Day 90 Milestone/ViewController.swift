//
//  ViewController.swift
//  Day 90 Milestone
//
//  Created by Maggie Maldjian on 8/19/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  var currentImage: UIImage?
  var topText = ""
  var bottomText = ""

  override func viewDidLoad() {
    
    navigationButtons()
    
    super.viewDidLoad()

  }


}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  @objc func selectPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    guard let image = info[.editedImage] as? UIImage else {return }
   
    dismiss(animated: true)
    
    currentImage = image
    
    imageView.image = image
    
  }
  
  @IBAction func addTopText(_ sender: UIButton) {
    guard currentImage != nil else { return }
    let topTextAlert = UIAlertController(title: "Enter Top Text", message: nil, preferredStyle: .alert)
    topTextAlert.addTextField()
    topTextAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    topTextAlert.addAction(UIAlertAction(title: "OK", style: .default) { [ weak self, weak topTextAlert] action in
      guard let text = topTextAlert?.textFields?[0].text else { return }
      self?.topText = text
      self?.processImage()
    })
    present(topTextAlert, animated: true)
  }
  
  @IBAction func addBottomText(_ sender: UIButton) {
    guard currentImage != nil else { return }
    let bottomTextAlert = UIAlertController(title: "Enter Bottom Text", message: nil, preferredStyle: .alert)
    bottomTextAlert.addTextField()
    bottomTextAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    bottomTextAlert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak bottomTextAlert] action in
      guard let text = bottomTextAlert?.textFields?[0].text else { return }
      self?.bottomText = text
      self?.processImage()
    })
    present(bottomTextAlert, animated: true)
  }

}

extension ViewController {
  
  func processImage() {
    guard let image = currentImage else { return }
    let renderer = UIGraphicsImageRenderer(size: image.size)
    
    let img = renderer.image { context in
      
      currentImage?.draw(at: CGPoint(x: 0, y: 0))
      
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Helvetica-Bold", size: 60) ?? .systemFont(ofSize: 40),
        .paragraphStyle: paragraphStyle,
        .foregroundColor: UIColor.white,
        .strokeColor: UIColor.black,
        .strokeWidth: -4
      ]
      
      let top = topText
      let bottom = bottomText
      let attributedStringTop = NSAttributedString(string: top, attributes: attributes)
      let attributedStringBottom = NSAttributedString(string: bottom, attributes: attributes)
      
//      let imageCenter = image.size.width / 2
      let center = imageView.frame.size.width / 2
      let imageSize = imageView.frame.size
      print(center)
      
      let rectTop = CGRect(x: center, y: 20, width: imageSize.width, height: imageSize.height)
      let rectBottom = CGRect(x: center, y: imageSize.height - 20, width: imageSize.width, height: imageSize.height)
      
      attributedStringTop.draw(with: rectTop, options: .usesLineFragmentOrigin, context: nil)
      attributedStringBottom.draw(with: rectBottom, options: .usesLineFragmentOrigin, context: nil)
    
    }
    imageView.image = img
  }
  
}

extension ViewController {
  func navigationButtons() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectPicture))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePicture))
  }
  
  @objc func sharePicture() {
    guard let image = imageView.image else { return }
    guard let imageToShare = image.jpegData(compressionQuality: 0.8) else { print ("No image found")
        return
      }
      
      let viewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: [])
      viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
      present (viewController, animated: true)
  }
  
}

