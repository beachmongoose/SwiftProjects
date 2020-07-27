//
//  ViewController.swift
//  Day 50 Milestone
//
//  Created by Maggie Maldjian on 7/27/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  var imageNames = [String]()
  var imageFiles = [String]()
  var images = [ImageData]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewSetup()
  }

}
extension ViewController{
  @objc func addImage() {
    let addImageAlert = UIAlertController(title: "Select Source", message: nil, preferredStyle: .alert)
    
    addImageAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
      if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
      self.cameraError()
      } else {
      self.usingCamera(with: action)
      }
      }))
    
    addImageAlert.addAction(UIAlertAction(title: "File", style: .default, handler: usingFile))
    
    present(addImageAlert, animated: true)
    
  }
  
  func usingCamera(with action: UIAlertAction) {
    let selector = UIImagePickerController()
    selector.sourceType = .camera
    selector.allowsEditing = true
    present(selector, animated: true)
  }
  func usingFile(action: UIAlertAction) {
    let selector = UIImagePickerController()
    selector.allowsEditing = true
    selector.delegate = self
    present(selector, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else {return}
    
    let imageName = UUID().uuidString
    let imagePath = documentsDirectory().appendingPathComponent(imageName)
    
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    let image = ImageData(image: imageName, name: "Untitled")
    images.append(image)
    tableView.reloadData()
    dismiss (animated: true)
    
  }
  
  func cameraError() {
    let cameraErrorAlert = UIAlertController(title: "Error", message: "Camera is not available.", preferredStyle: .alert)
    cameraErrorAlert.addAction(UIAlertAction(title: "OK", style: .default))
    present(cameraErrorAlert, animated: true)
  }
}

extension ViewController {
  func viewSetup() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addImage))
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return images.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "image", for: indexPath) as? ImageClass else {
        fatalError("Unable to dequeue imageData")
      }
      let cellImage = images[indexPath.item]
      cell.textLabel?.text = cellImage.name
      
      let path = documentsDirectory().appendingPathComponent(cellImage.image)
      cell.imageView?.image = UIImage(contentsOfFile: path.path)
      
      return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let imageViewController = storyboard?.instantiateViewController(withIdentifier: "viewScreen") as? DetailViewController {
        let cellImage = images[indexPath.row]
        imageViewController.cellImage = cellImage.image
        imageViewController.cellLabel = cellImage.name
        navigationController?.pushViewController(imageViewController, animated: true)
      }
      
    }
    
  }
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
