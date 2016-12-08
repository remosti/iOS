//
//  GamePlayViewController.swift
//  Music Cover Quiz
//
//  Created by Valentin Schuler on 01.12.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class GamePlayViewController: UIViewController {
    
    var correctAnswer: Int = 0
    var playedQuizData:[Int] = [1, 2, 3, 4, 5]
    
    var quizData: [QuizDataItem]?
    
    var youtubeUrl: String?
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var blurBackground: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        coverImage.layer.borderColor = UIColor.white.cgColor
        coverImage.layer.borderWidth = 1

        button1.layer.cornerRadius = 8
        button1.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        button1.titleLabel?.textAlignment = NSTextAlignment.center
        button1.titleLabel?.numberOfLines = 2
        
        button2.layer.cornerRadius = 8
        button2.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        button2.titleLabel?.textAlignment = NSTextAlignment.center
        button2.titleLabel?.numberOfLines = 2
        
        button3.layer.cornerRadius = 8
        button3.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        button3.titleLabel?.textAlignment = NSTextAlignment.center
        button3.titleLabel?.numberOfLines = 2

        hideNextButton()
        setupGame()
    }
    
    func setupGame () {

        let gameData: [QuizDataItem] = [(quizData?[0])!, (quizData?[1])!, (quizData?[2])!, (quizData?[3])! ]
        
        
        setupNextData(data: gameData)
        
 //       let randomIndex = Int(arc4random_uniform(UInt32((quizData?.count)!-1)))
  //      while playedQuizData.contains(randomIndex) { }
        
 //       playedQuizData.append(randomIndex)
        
 //       let random = Int(arc4random_uniform(UInt32((quizData?.count)!-1)))

     //playedQuizData.remove(at: randomIndex)
    }
    
    func setupNextData(data: [QuizDataItem]) {
        hideYoutubeLink()
        button1.setTitle("\(data[0].band)\n\(data[0].song)", for: UIControlState.normal)
        button2.setTitle("\(data[1].band)\n\(data[1].song)", for: UIControlState.normal)
        button3.setTitle("\(data[2].band)\n\(data[2].song)", for: UIControlState.normal)
        
        correctAnswer = Int(arc4random_uniform(3));
        coverImage.image = data[correctAnswer].getLocalCoverImage()
        
        youtubeUrl = data[correctAnswer].youtube
    }
    
    @IBAction func button1Pressed(_ sender: UIButton) {
        showNextButton()
        showYoutubeLink()
        button1.tintColor = UIColor.black
        if (correctAnswer == 0) {
            button1.layer.backgroundColor = UIColor.green.cgColor
        } else {
            button1.layer.backgroundColor = UIColor.red.cgColor
        }
    }
    
    @IBAction func button2Pressed(_ sender: UIButton) {
        showNextButton()
        showYoutubeLink()
        button2.tintColor = UIColor.black
        if (correctAnswer == 1) {
            button2.layer.backgroundColor = UIColor.green.cgColor
        } else {
            button2.layer.backgroundColor = UIColor.red.cgColor
        }
    }
    
    @IBAction func button3Pressed(_ sender: UIButton) {
        showNextButton()
        showYoutubeLink()
        button3.tintColor = UIColor.black
        if (correctAnswer == 2) {
            button3.layer.backgroundColor = UIColor.green.cgColor
        } else {
            button3.layer.backgroundColor = UIColor.red.cgColor
        }
    }
    
    @IBAction func youtubeButtonPressed(_ sender: UIButton) {
        if let url = URL(string: youtubeUrl!) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
      //  setupNextData()
    }
    
    func hideNextButton () {
        nextButton.isHidden = true
    }
    
    func showNextButton () {
        nextButton.isHidden = false
    }
    
    func showYoutubeLink() {
        youtubeButton.isHidden = false
        blurBackground.isHidden = false
    }
    
    func hideYoutubeLink() {
        youtubeButton.isHidden = true
        blurBackground.isHidden = true
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
