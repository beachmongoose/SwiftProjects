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
      guard let selectedImage = selectedImage else { return }
          guard let image = imageView.image else { return }
          let renderer = UIGraphicsImageRenderer(size: image.size)
          let img = renderer.image { context in
            
            let pic = UIImage(named: selectedImage)
            pic?.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
              paragraphStyle.alignment = .center
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20), .paragraphStyle: paragraphStyle, .foregroundColor: UIColor.white]
            let string = "From Storm Viewer"
            let attributedString = NSAttributedString(string: string, attributes: attributes)
              attributedString.draw(with: CGRect(x: 5, y: 5, width: image.size.width, height: image.size.height), options: .usesLineFragmentOrigin, context: nil)
          
          }
          guard let imageToShare = img.jpegData(compressionQuality: 0.8) else { print ("No image found")
            return
          }
          
          let viewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: [])
          viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
          present (viewController, animated: true)
        }

      }
