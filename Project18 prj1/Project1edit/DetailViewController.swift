//
//  DetailViewController.swift
//  Project1edit
//
//  Created by Maggie Maldjian on 7/21/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  
    var selectedImage: String?
    var picNumber = 0
    var picCount = 0
    
      override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picture \(picNumber) of \(picCount)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        if let imageToLoad = selectedImage {
          imageView.image = UIImage(named: imageToLoad)
          assert(selectedImage != nil, "No Image Selected")
          }
      }
      override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
             }
       override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
                }
    @objc func shareTapped() {
      guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { print ("No image found")
        return
      }
      
      let viewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
      viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
      present (viewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
