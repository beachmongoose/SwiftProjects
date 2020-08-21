//
//  ViewController.swift
//  Day 90 Milestone
//
//  Created by Maggie Maldjian on 8/19/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var bottomTextButton: UIButton!
  @IBOutlet var topTextButton: UIButton!
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

  // MARK: - Add Image
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
    
    topText = ""
    bottomText = ""
    
  }
 
  // MARK: - Add Text
  @IBAction func addTopText(_ sender: UIButton) {
    addText(placement: "Top", sender: topTextButton)
  }
  
  @IBAction func addBottomText(_ sender: UIButton) {
    addText(placement: "Bottom", sender: bottomTextButton)
  }
  
  func addText(placement: String, sender: UIButton) {
    guard currentImage != nil else { return }
    let textAlert = UIAlertController(title: "Enter \(placement) Text", message: nil, preferredStyle: .alert)
    textAlert.addTextField()
    textAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    textAlert.addAction(UIAlertAction(title: "OK", style: .default) { [ weak self, weak textAlert] action in
      guard let text = textAlert?.textFields?[0].text else { return }
      if sender == self?.topTextButton {
        self?.topText = text
      } else {
        self?.bottomText = text
      }
      self?.processImage()
    })
    present(textAlert, animated: true)
  }

}

// MARK: - Process Image
extension ViewController {
  
  func processImage() {
    guard let image = currentImage else { return }
    
    let renderer = UIGraphicsImageRenderer(size: image.size)
    
    let img = renderer.image { context in
      
      image.draw(at: CGPoint(x: 0, y: 0))
      
      createText(for: topText, at: 0)
      createText(for: bottomText, at: bottomY)
    
    }
    imageView.image = img
  }
  
  func createText(for textPart: String, at yAxis: CGFloat) {
    guard let imageSize = currentImage?.size else { return }
    let attributedString = NSAttributedString(string: textPart, attributes: attributes)
    
    let imageWidth = imageSize.width
    let imageHeight = imageSize.height
    
    let rect = CGRect(x: 0, y: yAxis, width: imageWidth, height: imageHeight)
    
    attributedString.draw(with: rect, options: .usesLineFragmentOrigin, context: nil)
    
  }
  
  
}

// MARK: - Buttons
extension ViewController {
  func navigationButtons() {
    
    let addPic = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectPicture))
    navigationItem.leftBarButtonItem = addPic
    let sharePic = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePicture))
    navigationItem.rightBarButtonItem = sharePic
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

// MARK: - Text Style
extension ViewController {
  var attributes: [NSAttributedString.Key : Any] {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    let fullSize = (currentImage?.size.width)! + (currentImage?.size.height)!
    let fontSize = fullSize / 20
    
    return [
      .font: UIFont(name: "Helvetica-Bold", size: fontSize) ?? .systemFont(ofSize: 40),
      .paragraphStyle: paragraphStyle,
      .foregroundColor: UIColor.white,
      .strokeColor: UIColor.black,
      .strokeWidth: -4
    ]
  }
  
// MARK: - Bottom Alignment
  func checkText(_ text: String, _ width: Int) -> Int {
      let nsText = NSString(string: text)
      let size = CGSize(width: CGFloat(width), height: .greatestFiniteMagnitude)
      let textRect = nsText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

      return Int(ceil(textRect.size.height))
  }
  
  var bottomY: CGFloat {
    guard let image = currentImage?.size else { return (imageView?.image?.size.width)! - 80 }
    
    let imageHeight = image.height
    let textWidth = Int(image.width) - 14
    let textHeight = checkText(bottomText, textWidth)
    return (imageHeight) - CGFloat(textHeight)
  }
