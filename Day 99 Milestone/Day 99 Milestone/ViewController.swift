//
//  ViewController.swift
//  Day 99 Milestone
//
//  Created by Maggie Maldjian on 8/25/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

enum cardError: Error {
  case noCard
}

class ViewController: UIViewController {
  @IBOutlet var cardView: UIView!
  var pictureCards = [UIImage]()
  var textCards = [UIImage]()
  
  var cardButtons = [UIButton]()
  var cardBack = UIImage()
  
  var cardOne: UIButton?
  var cardTwo: UIButton?
  
  var tries = 0 {
    didSet {
      navigationButtons()
    }
  }
  
  override func viewDidLoad() {
    navigationButtons()
    organizeCards()
    buttonSetup()
    
    super.viewDidLoad()
  }


}

// MARK: - Setup
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
        card.layer.cornerRadius = 5
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
}

// MARK: - Card Actions
extension ViewController {
  @objc func cardTapped(sender: UIButton) {
    flipToReveal(sender)
      if cardOne == nil {
        self.cardOne = sender
        } else {
      cardTwo = sender
      checkForMatch()
    }
  }
  
  func flipToReveal(_ card: UIButton) {
    
  }
    
    func checkForMatch() {
      guard let cardOne = self.cardOne?.imageView?.image else { return }
      guard let cardTwo = self.cardTwo?.imageView?.image else { return }
      do {
        let index1 = try getCardDetails(for: cardOne)
        let index2 = try getCardDetails(for: cardTwo)
        
        if index1 == index2 {
          tries += 1
          cardMatch()
        } else {
          tries += 1
          flipBackOver(self.cardOne)
          self.cardOne = nil
          flipBackOver(self.cardTwo)
          self.cardTwo = nil
        }
      }
      catch {
        print("No card")
      }
    }
    
    func getCardDetails(for selectedCard: UIImage) throws -> Array<UIImage>.Index {
      if pictureCards.contains(selectedCard) {
          guard let number = pictureCards.firstIndex(of: selectedCard) else { throw cardError.noCard }
          return number
        } else {
          guard let number = textCards.firstIndex(of: selectedCard) else { throw cardError.noCard }
        return number
        }
      }
    
    func cardMatch() {
      disappear(self.cardOne)
      self.cardOne = nil
      disappear(self.cardTwo)
      self.cardTwo = nil
    }
    
    func flipBackOver(_ card: UIButton?) {
      guard let selectedCard = card else { return }
      selectedCard.isHidden = false
    }
    
    func disappear(_ selectedCard: UIButton?) {
      guard let card = selectedCard else { return }
      UIView.animate(withDuration: 0.5, delay: 0, animations: {
        card.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
      }) { _ in
        card.isHidden = true
        if self.allButtonsHidden() {
          self.gameWin()
        }
      }
    }
}

// MARK: Game Status
extension ViewController {
  
  func allButtonsHidden() -> Bool {
    for card in cardButtons {
      if card.isHidden == false {
        return false
      }
    }
    return true
  }
  
  func gameWin() {
    let winAlert = UIAlertController(title: "You Win!", message: "Turns Taken: \(tries)", preferredStyle: .alert)
    winAlert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: resetGame))
    present(winAlert, animated: true)
  }
  
  func resetGame(action: UIAlertAction) {
    for button in cardButtons {
      button.isHidden = false
      UIView.animate(withDuration: 0, animations: {
        button.transform = .identity
      })
    }
    
    tries = 0
    addCardPics(to: cardButtons)
  }
}

// MARK: - Controls
extension ViewController {
  func navigationButtons() {
    let triesIndicator = UIBarButtonItem(title: "Tries: \(tries)", style: .plain, target: self, action: nil)
    navigationItem.rightBarButtonItem = triesIndicator
    let reset = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetAlert))
    navigationItem.leftBarButtonItem = reset
  }
  
  @objc func resetAlert() {
    let resetAlert = UIAlertController(title: "Reset Game?", message: nil, preferredStyle: .alert)
    resetAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    resetAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: resetGame))
    present(resetAlert, animated: true)
  }
}
