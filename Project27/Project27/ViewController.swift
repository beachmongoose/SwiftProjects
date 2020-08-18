//
//  ViewController.swift
//  Project27
//
//  Created by Maggie Maldjian on 8/18/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  var currentDrawType = 0
  override func viewDidLoad() {
    drawRectangle()
    super.viewDidLoad()
  }
}

extension ViewController {
  @IBAction func redrawTapped(_ sender: Any) {
    currentDrawType += 1
    
    if currentDrawType > 5 {
      currentDrawType = 0
    }
    
    switch currentDrawType {
    case 0:
      drawRectangle()
      
    case 1:
      drawCircle()
    
    case 2:
      drawCheckerBoard()
      
    case 3:
      drawRotatedSquares()
      
    case 4:
      drawLines()
      
    case 5:
      drawingImagesAndText()
    
    default:
      break
    }
  }
  
  func drawRectangle() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { context in
      let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
      
      context.cgContext.setFillColor(UIColor.red.cgColor)
      context.cgContext.setStrokeColor(UIColor.black.cgColor)
      context.cgContext.setLineWidth(10)
      
      context.cgContext.addRect(rectangle)
      context.cgContext.drawPath(using: .fillStroke)
    }
    imageView.image = img
  }
  
  func drawCircle() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
  
    let img = renderer.image { context in
      let circle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
    
      context.cgContext.setFillColor(UIColor.red.cgColor)
      context.cgContext.setStrokeColor(UIColor.black.cgColor)
      context.cgContext.setLineWidth(10)
    
      context.cgContext.addEllipse(in: circle)
      context.cgContext.drawPath(using: .fillStroke)
    }
    imageView.image = img
  }
  
  func drawCheckerBoard() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { context in
      context.cgContext.setFillColor(UIColor.black.cgColor)
      
      for row in 0..<8{
        for col in 0..<8 {
          if (row + col) % 2 == 0 {
            context.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
          }
        }
      }
    }
    
    imageView.image = img
  }
  func drawRotatedSquares() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    let img = renderer.image { context in
      context.cgContext.translateBy(x: 256, y: 256)
      
      let rotations = 16
      let amount = Double.pi / Double(rotations)
      
      for _ in 0..<rotations {
        context.cgContext.rotate(by: CGFloat(amount))
        context.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
      }
      
      context.cgContext.setStrokeColor(UIColor.black.cgColor)
      context.cgContext.strokePath()
    }
    imageView.image = img
  }
  
  func drawLines() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { context in
      context.cgContext.translateBy(x: 256, y: 256)
      
      var first = true
      var length: CGFloat = 256
      for _ in 0..<256 {
        context.cgContext.rotate(by: .pi / 2)
        
        if first {
          context.cgContext.move(to: CGPoint(x: length, y: 50))
          first = false
        } else {
          context.cgContext.addLine(to: CGPoint(x: length, y: 50))
        }
        length += 0.99
      }
      context.cgContext.setStrokeColor(UIColor.black.cgColor)
      context.cgContext.strokePath()
    }
    imageView.image = img
  }
  
  func drawingImagesAndText() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
    let img = renderer.image { context in
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      
      let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 36), .paragraphStyle: paragraphStyle
      ]
      
      let string = "The best-laid schemes o'\nmice an' men gang aft agley"
      let attributedString = NSAttributedString(string: string, attributes: attributes)
      
      attributedString.draw(with: CGRect(x: 32, y: 32, width: 488, height: 488), options: .usesLineFragmentOrigin, context: nil)
      
      let mouse = UIImage(named: "mouse")
      mouse?.draw(at: CGPoint(x: 300, y: 150))
    }
    
    imageView.image = img
  }
}

