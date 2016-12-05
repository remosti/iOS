//
//  GamePlayViewController.swift
//  Music Cover Quiz
//
//  Created by Valentin Schuler on 01.12.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController {
    
    var correctAnswer = String()
    var playedQuizData:[Int] = [1, 2, 3, 4, 5]
    
    var quizData: [QuizDataItem]?
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var coverImage: UIImageView!

    @IBOutlet weak var labelEnd: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        let cornerRadius : CGFloat = 8
        button1.layer.cornerRadius = cornerRadius
        button2.layer.cornerRadius = cornerRadius
        button3.layer.cornerRadius = cornerRadius

        hideNextButton()
        setupGame()
    }
    
    func setupGame () {
        
        if let data = quizData?[0] {
            if let image = data.getLocalCoverImage() {
                coverImage.image = image
                button1.setTitle ("\(data.band) - \(data.song)", for: UIControlState.normal)
            }
        }
        
 //       let randomIndex = Int(arc4random_uniform(UInt32((quizData?.count)!-1)))
  //      while playedQuizData.contains(randomIndex) { }
        
 //       playedQuizData.append(randomIndex)
        
 //       let random = Int(arc4random_uniform(UInt32((quizData?.count)!-1)))

        
//        button1.setTitle (quizData?[0].song, for: UIControlState.normal)
//        button2.setTitle ("Karlos", for: UIControlState.normal)
//        button3.setTitle ("William", for: UIControlState.normal)
//        correctAnswer = "2"
    
  //      playedQuizData.remove(at: randomIndex)
    }
    
    func setupNextData() {}
    
    @IBAction func button1Pressed(_ sender: UIButton) {
        showNextButton()
        if (correctAnswer == "1") {
            labelEnd.text = "Richtig!"
        } else{
            labelEnd.text = "Falsch!"
        }
    }
    
    @IBAction func button2Pressed(_ sender: UIButton) {
        showNextButton()
        if (correctAnswer == "2") {
            labelEnd.text = "Richtig!"
        } else{
            labelEnd.text = "Falsch!"
        }
    }
    
    @IBAction func button3Pressed(_ sender: UIButton) {
        showNextButton()
        if (correctAnswer == "3") {
            labelEnd.text = "Richtig!"
        } else{
            labelEnd.text = "Falsch!"
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        setupNextData()
    }
    
    func hideNextButton () {
        nextButton.isHidden = true
    }
    
    func showNextButton () {
        nextButton.isHidden = false
    }
    
    func shuffleArray(array: [Int]) -> [Int] {
        var tempArray = array
        for index in 0...array.count - 1 {
            let randomNumber = arc4random_uniform(UInt32(array.count - 1))
            let randomIndex = Int(randomNumber)
            tempArray[randomIndex] = array[index]
        }
        
        return tempArray
    }
    
   
}
