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
    
    let blue = UIColor(red: 0.0/255.0, green: 166.0/255.0, blue: 255.0/255.0, alpha: 1.0)

    var correctAnswer: Int = 0
    
    var quizData: [QuizDataItem]?
    
    var youtubeUrl: String?
    
    var shuffledQuizDataIndex: [Int]?

    var playRound = 0
    
    var animator: UIViewPropertyAnimator?
    var counter = 0.0
    var scoreTotal = 0
    
    var timer: Timer?

    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var blurBackground: UIVisualEffectView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var blurView: UIVisualEffectView!

    @IBOutlet weak var score: UILabel!
    
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
        
        animator = UIViewPropertyAnimator(duration: 1, curve: .easeOut) {
            self.blurView.effect = nil
        }

        resetGameplayView()
        showStartButton()
    }
    
    func setupGame() {
        playRound = 1
        scoreTotal = 0
        score.text = "0"
        shuffledQuizDataIndex = shuffleArray(array: Array(0...19))
        setupNextData()
        resetGameplayView()
    }
    
    func setupNextData() {
        let gameData: [QuizDataItem] = [
            (quizData?[shuffledQuizDataIndex![0 + 3*(playRound-1)]])!,
            (quizData?[shuffledQuizDataIndex![1 + 3*(playRound-1)]])!,
            (quizData?[shuffledQuizDataIndex![2 + 3*(playRound-1)]])!
        ]
        
        button1.setTitle("\(gameData[0].band)\n\(gameData[0].song)", for: UIControlState.normal)
        button2.setTitle("\(gameData[1].band)\n\(gameData[1].song)", for: UIControlState.normal)
        button3.setTitle("\(gameData[2].band)\n\(gameData[2].song)", for: UIControlState.normal)

        correctAnswer = Int(arc4random_uniform(3));
        coverImage.image = gameData[correctAnswer].getLocalCoverImage()
        youtubeUrl = gameData[correctAnswer].youtube
        
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.stepUnblur), userInfo: nil, repeats: true);
    }
    
    func resetGameplayView() {
        resetBlur()
        hideNextButton()
        hideYoutubeButton()
        hideStartButton()
        
        button1.layer.backgroundColor = self.blue.cgColor
        button2.layer.backgroundColor = self.blue.cgColor
        button3.layer.backgroundColor = self.blue.cgColor
        
        button1.tintColor = UIColor.white
        button2.tintColor = UIColor.white
        button3.tintColor = UIColor.white
        
        button1.isEnabled = true
        button2.isEnabled = true
        button3.isEnabled = true
    }
   
    @IBAction func button1Pressed(_ sender: UIButton) {
        evaluate(answer: correctAnswer == 0)
        button1.tintColor = UIColor.black
        button1.layer.backgroundColor = (correctAnswer == 0) ? UIColor.green.cgColor : UIColor.red.cgColor
        button2.isEnabled = false
        button3.isEnabled = false
    }
    
    @IBAction func button2Pressed(_ sender: UIButton) {
        showYoutubeButton()
        evaluate(answer: correctAnswer == 1)
        button2.tintColor = UIColor.black
        button2.layer.backgroundColor = (correctAnswer == 1) ? UIColor.green.cgColor : UIColor.red.cgColor
        button1.isEnabled = false
        button3.isEnabled = false
    }
    
    @IBAction func button3Pressed(_ sender: UIButton) {
        showYoutubeButton()
        evaluate(answer: correctAnswer == 2)
        button3.tintColor = UIColor.black
        button3.layer.backgroundColor = (correctAnswer == 2) ? UIColor.green.cgColor : UIColor.red.cgColor
        button1.isEnabled = false
        button2.isEnabled = false
    }
    
    @IBAction func youtubeButtonPressed(_ sender: UIButton) {
        if let url = URL(string: youtubeUrl!) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        setupNextData()
        resetGameplayView()
      }
    

    @IBAction func homeButtonPressed(_ sender: UIButton) {
        if self.playRound != 0 {
            let ac = UIAlertController(title: "Music Cover Quiz", message: "Wollen Sie das aktuelle Spiel wirklich abbrechen?", preferredStyle: .alert)
            
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            ac.addAction(UIAlertAction(title: "Zurück", style: .default))
            ac.addAction(okAction)
            self.present(ac, animated: true)
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        setupGame()
    }
    
    func evaluate(answer correct: Bool) {
        timer?.invalidate()
        timer = nil
        unblur()
        showYoutubeButton()
        
        if correct {
            scoreTotal += Int(10 - self.counter * 10)
            self.score.text = String(scoreTotal)
        }

        if self.playRound == 5 {
            let ac = UIAlertController(title: "Music Cover Quiz", message: "Gratulation", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "Danke", style: .default) { action -> Void in
                self.showStartButton()
            }
            ac.addAction(okAction)
            self.present(ac, animated: true)
            self.playRound = 0
        } else {
            self.playRound += 1
            showNextButton()
        }
    }
    
    func stepUnblur() {
        animator?.fractionComplete = CGFloat(counter)
        progressBar.progress = Float(1 - counter)
        counter += 0.005
    }
    
    func unblur() {
        animator?.fractionComplete = 1.0
    }
    
    func resetBlur() {
        counter = 0
        animator?.fractionComplete = CGFloat(0)
        progressBar.progress = Float(1 - counter)
    }

    
    func showNextButton() {
        nextButton.isHidden = false
    }
    
    func hideNextButton() {
        nextButton.isHidden = true
    }
    
    func showYoutubeButton() {
        youtubeButton.isHidden = false
        blurBackground.isHidden = false
    }
    
    func hideYoutubeButton() {
        youtubeButton.isHidden = true
        blurBackground.isHidden = true
    }
    
    func showStartButton() {
        startButton.isHidden = false
    }
    
    func hideStartButton() {
        startButton.isHidden = true
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
