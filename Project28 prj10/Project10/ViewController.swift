//
//  ViewController.swift
//  Project10
//
//  Created by Maggie Maldjian on 7/23/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var people = [Person]()
  
  override func viewDidLoad() {

    authentication()
    
    super.viewDidLoad()
  }
}

// MARK: - Add Contact
extension ViewController {
  
  @objc func addNewPerson() {
    let selectSource = UIAlertController(title: "Select Source", message: nil, preferredStyle: .alert)
    
    selectSource.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
      if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
        self.cameraError()
      } else {
        self.usingCamera(with: action)
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
  
  func usingCamera(with action: UIAlertAction) {
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
    save()
  }
  
}

// MARK: - Edit Contact
extension ViewController {
  
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
      self?.save()
    })
    
    present(contactRename, animated: true)
    
  }
}

extension ViewController {
  func save() {
    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "people")
    }
  }
  
  func loadData() {
    let defaults = UserDefaults.standard
    if let savedPeople = defaults.object(forKey: "people") as? Data {
      if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
        people = decodedPeople
      }
    }
  }
}


// MARK: - View Setup
extension ViewController {
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
  
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}

extension ViewController {
  func authentication() {
    let context = LAContext()
    var error: NSError?
    
    guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
      showError(title: "Biometry Unavailable", message: "Your device is not configured for biometric authetication");
      return
    }
      let reason = "Confirm Identity"
      
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
        [weak self ] success, authenticationError in
        DispatchQueue.main.async {
          if success {
            self?.loadData()
            self?.setAddButton()
            self?.collectionView.reloadData()
          } else {
            self?.showError(title: "Authentication Failed",
                            message: "You could not be verified; pelase try again.")
          }
        }
      }
    }
  
  func showError (title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(alertController, animated: true)
  }
  
  func setAddButton() {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    navigationItem.leftBarButtonItem = addButton
  }

}
