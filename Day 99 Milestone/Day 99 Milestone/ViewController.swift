//
//  ViewController.swift
//  Day 99 Milestone
//
//  Created by Maggie Maldjian on 8/25/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var cardView: UIView!
  var tries = 0
  var pictureCards = [UIImage]()
  var textCards = [UIImage]()
  var cardButtons = [UIButton]()
  var cardBacks = [UIButton]()
  
  override func viewDidLoad() {
    organizeCards()
    buttonSetup()
    
    super.viewDidLoad()
  }


}

extension ViewController {
  func getCards(from starting: Int, to ending: Int) -> [UIImage] {
    var array = [UIImage]()
    for n in starting...ending {
      let card = UIImage(named: "cards\(n)")!
      array.append(card)
    }
    return array
  }
  
  func organizeCards() {
    pictureCards.append(contentsOf: getCards(from: 0, to: 7))
    textCards.append(contentsOf: getCards(from: 8, to: 15))
  }
}

extension ViewController {
  func buttonSetup() {
    let width = 130
    let height = 181
    
    var offsetX = 20
    var offsetY = 0
    var x = 0
    for row in 0..<4 {
      for col in 0..<4 {
        
        let card = UIButton(type: .custom)
        card.layer.backgroundColor = UIColor.white.cgColor
        card.layer.cornerRadius = 3
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.gray.cgColor
        
        let frame = CGRect(x: (col * width) + offsetX, y: (row * height) + offsetY, width: width, height: height)
        card.frame = frame
        cardView.addSubview(card)
        cardButtons.append(card)
        card.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
        offsetX += 20
        x += 1
        if x == 4 {
          x = 0
          offsetX = 20
          offsetY += 20
        }
      }
    }
    addCardPics(to: cardButtons)
  }
    
    func addCardPics(to buttons: [UIButton]) {
       DispatchQueue.main.async {
        
        var cards = self.pictureCards + self.textCards
        cards.shuffle()
        
          if cards.count == buttons.count {
             for i in 0 ..< buttons.count {
                buttons[i].setImage(cards[i], for: .normal)
          }
        }
      }
    }
    
  
  @objc func cardTapped() {
    
  }
  
}

