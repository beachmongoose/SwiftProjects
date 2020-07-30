//
//  ViewController.swift
//  Day 50 Milestone
//
//  Created by Maggie Maldjian on 7/27/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
  var images = [ImageData]()

  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addImage))
    
    let longPressCheck = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
    view.addGestureRecognizer(longPressCheck)
  }

// MARK: - Add Image
}
extension ViewController {
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
  
  func cameraError() {
    let cameraErrorAlert = UIAlertController(title: "Error", message: "Camera is not available.", preferredStyle: .alert)
    cameraErrorAlert.addAction(UIAlertAction(title: "OK", style: .default))
    present(cameraErrorAlert, animated: true)
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
    let newImage = ImageData(imagePath: imageName, name: "Untitled")
    dismiss (animated: true)
    setName(for: newImage)
  }
  
  func setName(for image: ImageData) {
    var newPic = image
    let nameImage = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
    nameImage.addTextField()
    nameImage.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    nameImage.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak nameImage] _ in
      guard let newName = nameImage?.textFields?[0].text else {return}
      newPic.name = newName
      self!.images.append(newPic)
      self?.save(all: self!.images)
      self?.tableView.reloadData()
      })
      
      present(nameImage, animated: true)
  }
}

// MARK: - Image Options
extension ViewController {
  @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
    if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
      let touchPoint = longPressGestureRecognizer.location(in: self.view)
      if let indexPath = tableView.indexPathForRow(at: touchPoint) {
        showImageOptions(with: indexPath)
      }
    }
  }
  
  func showImageOptions(with path: IndexPath) {
    let image = images[path.row]
    let imageSelect = UIAlertController(title: "Contact Selected", message: nil, preferredStyle: .alert)
        
    imageSelect.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
      self.images.remove(at: path.row)
      self.tableView.reloadData()
    }))
        
    imageSelect.addAction(UIAlertAction(title: "Rename", style: .default, handler: { action in
      self.rename(image, at: path.row)
    }))

    present(imageSelect, animated: true)
  }
  
  func rename(_ image: ImageData, at index: Int) {
    let imageRename = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
    imageRename.addTextField()
    imageRename.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    imageRename.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak imageRename] _ in
      guard let self = self else { return }
      guard let newName = imageRename?.textFields?[0].text else {return}
      let renamedImage = ImageData(imagePath: image.imagePath, name: newName)
      self.images[index] = renamedImage
      self.save(all: self.images)
      self.tableView.reloadData()
    })
    present(imageRename, animated: true)
  }
  

}

// MARK: - View Setup
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return images.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "Table", for: indexPath) as? ImageCell else {
        fatalError("Unable to dequeue")
      }
      
      let currentData = images[indexPath.row]
      cell.pictureTitleLabel?.text = currentData.name
      cell.picture.image = currentData.displayImage
      
      return cell
    }
    
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 140.0
  }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let imageViewController = storyboard?.instantiateViewController(withIdentifier: "ViewScreen") as? DetailViewController {
        let cellImage = images[indexPath.row]
        imageViewController.image = cellImage.displayImage
        imageViewController.imageLabel = cellImage.name
        navigationController?.pushViewController(imageViewController, animated: true)
      }
    }
  
  func save(all data: [ImageData]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(data) {
      let defaults = UserDefaults.standard
      defaults.set(encoded, forKey: "ImageData")
    }
  }
  
  func loadData() {
    let defaults = UserDefaults.standard
    
    if let savedData = defaults.object(forKey: "ImageData") as? Data {
      let jsonDecoder = JSONDecoder()
      
      do {
        images = try
          jsonDecoder.decode([ImageData].self, from: savedData)
      } catch {
        print("Failed to load")
      }
    }
  }
  
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
