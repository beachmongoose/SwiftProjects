func submit(_ answer: String){
  let lowerAnswer = answer.lowercased()
  guard let isPossible(word: lowerAnswer) == true else {
  showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title)")
  }
  if isPossible(word: lowerAnswer){
    if isOriginal(word: lowerAnswer){
      if isReal(word: lowerAnswer){
        if isWord(word: lowerAnswer){
        usedWords.insert (answer, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        return
        } else {
          showErrorMessage(errorTitle: "Root Word", errorMessage: "That's the word you were given!")
        }
      } else {
        showErrorMessage(errorTitle: "World not recognized", errorMessage: "You can't just make them up, you know!")
      }
    } else {
      showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
    }
}
