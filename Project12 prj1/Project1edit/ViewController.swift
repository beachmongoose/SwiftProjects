//
//  ViewController.swift
//  Project1edit
//
//  Created by Maggie Maldjian on 7/21/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
var pictures = [String]()
var images = [Image]()

    override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .never
    title = "Storm Viewer"
  
    loadImages()
  
}
  @objc func loadImages(){
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    for item in items {
        if item.hasPrefix("nssl") {
            pictures.append(item)
            pictures.sort()
        }
    }
  }


override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
return pictures.count }
  
override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath) as? ImageCell else {
      fatalError("Didn't work")
      }
    let picture = pictures[indexPath.row]
    cell.image.image = UIImage(named: picture)
    cell.name.text = pictures[indexPath.row]
    cell.image.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
    cell.image.layer.borderWidth = 2
    cell.image.layer.cornerRadius = 3
    cell.layer.cornerRadius = 7
    return cell
    }
  
override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
        detailViewController.selectedImage = pictures[indexPath.row]
        detailViewController.picCount = pictures.count
        detailViewController.picNumber = indexPath.row + 1
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
}


