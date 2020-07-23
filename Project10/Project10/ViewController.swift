//
//  ViewController.swift
//  Project10
//
//  Created by Maggie Maldjian on 7/23/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var people = [Person]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return people.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
          fatalError("Unable to dequeue PersonCell.")
      }
    let person = people[indexPath.item]
    
    cell.name.text = person.name
    
    let path = documentsDirectory().appendingPathComponent(person.image)
    cell.imageView.image = UIImage(contentsOfFile: path.path)
    
    cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
    cell.imageView.layer.borderWidth = 2
    cell.imageView.layer.cornerRadius = 3
    cell.layer.cornerRadius = 7
    
    return cell
    
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let person = people[indexPath.item]
  
    let contactSelect = UIAlertController(title: "Contact Selected", message: nil, preferredStyle: .alert)
        
    contactSelect.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
      self.people.remove(at: indexPath.item)
      self.collectionView.reloadData()
    }))
        
    contactSelect.addAction(UIAlertAction(title: "Rename", style: .default, handler: { action in
      self.rename(person)
    }))

    present(contactSelect, animated: true)
  }
  func rename(_ cell : Person) {
    let person = cell
    let contactRename = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
    contactRename.addTextField()
    
    contactRename.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    
    contactRename.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak contactRename] _ in
      guard let newName = contactRename?.textFields?[0].text else {return}
      person.name = newName
      
      self?.collectionView.reloadData()
      
    })
    
    present(contactRename, animated: true)
    
  }
}

extension ViewController {
  
  @objc func addNewPerson() {
    let selectSource = UIAlertController(title: "Select Source", message: nil, preferredStyle: .alert)
    
    selectSource.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
      if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
        self.cameraError()
        }
    }))
    
    selectSource.addAction(UIAlertAction(title: "Library", style: .default, handler: usingLibrary))
    
    present(selectSource, animated: true)
    }
  
  func usingLibrary(action: UIAlertAction) {
    let selector = UIImagePickerController()
    selector.allowsEditing = true
    selector.delegate = self
    present(selector, animated: true)
  }
  
  func usingCamera(action: UIAlertAction) {
    let selector = UIImagePickerController()
    selector.sourceType = .camera
    selector.allowsEditing = true
    present(selector, animated: true)
  }
  
  func cameraError() {
      let cameraAlert = UIAlertController (title: "Error", message: "Camera not available.", preferredStyle: .alert)
      cameraAlert.addAction(UIAlertAction(title: "Back", style: .default))
      
      present (cameraAlert, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else {return }
    
    let imageName = UUID().uuidString
    let imagePath = documentsDirectory().appendingPathComponent(imageName)
    
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    let person = Person(name: "Unknown", image: imageName)
    people.append(person)
    collectionView.reloadData()
    dismiss (animated: true)
  }
  
  
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
