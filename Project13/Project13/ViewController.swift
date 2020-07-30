//
//  ViewController.swift
//  Project13
//
//  Created by Maggie Maldjian on 7/30/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var intensity: UISlider!
  @IBOutlet var filterButton: UIButton!
  var currentImage: UIImage!
  var context: CIContext!
  var currentFilter: CIFilter!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "YACIFP"
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    
    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone")
    filterButton.setTitle(currentFilter.name, for: .normal)
    
  }

  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      guard let image = info[.editedImage] as? UIImage else { return }
    
      dismiss(animated: true)
    
      currentImage = image
    let beginImage = CIImage(image: currentImage)

    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

    applyProcessing()
  }

}

extension ViewController {
  @IBAction func changeFilter(_ sender: Any) {
    let filters = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
    filters.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
    filters.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
    filters.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
    filters.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
    filters.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
    filters.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
    filters.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
    filters.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(filters, animated: true)
  }
  
  func setFilter(action: UIAlertAction) {
    guard currentImage != nil else {
      showMessage(title: "Error", message: "Please select image first.")
      return }
    
    guard let actionTitle = action.title else { return }
    
    currentFilter = CIFilter(name: actionTitle)

    let beginImage = CIImage(image: currentImage)
    filterButton.setTitle(currentFilter.name, for: .normal)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    applyProcessing()
  }
  
  @IBAction func save(_ sender: Any) {
      guard let image = imageView.image else {
        showMessage(title: "Save Error", message: "No image to save.")
      return }
      
      UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
  
  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      showMessage(title: "Save error", message: error.localizedDescription)
      return
    } else {
      showMessage(title: "Saved!", message: "Your altered image has been saved to your photos.")
    }
  }
  
  @IBAction func intensityChanged(_ sender: Any) {
    applyProcessing()
  }
  func applyProcessing() {
    let inputKeys = currentFilter.inputKeys
    
    if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
    if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
    if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
    if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
    if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
      let processedImage = UIImage(cgImage: cgimg)
      self.imageView.image = processedImage
    }
  }
  
  func showMessage (title: String, message: String) {
    let alertController = UIAlertController(title: title,message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(alertController, animated: true)
  }
}

