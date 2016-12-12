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

    var correctAnswer: Int = -1
    
    var quizData: [QuizDataItem]?
    
    var youtubeUrl: String?
    
    var shuffledQuizDataIndex: [Int]?

    let maxPlayRound = 5
    var playRound = 0
    var counter = 0
    var score = 0
    
    var timer: Timer?
    
    let effectView = UIVisualEffectView()
    let alpha  = [1.0, 0.98, 0.95, 0.92, 0.9, 0.85, 0.8, 0.75, 0.7, 0.4, 0.2, 0.0]

    
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
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var progressBar: UIProgressView!

    @IBOutlet weak var pointsButton1: UILabel!
    @IBOutlet weak var pointsButton2: UILabel!
    @IBOutlet weak var pointsButton3: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playRoundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        coverImage.layer.borderColor = UIColor.white.cgColor
        coverImage.layer.borderWidth = 1

        initButtonStyle(button: button1)
        initButtonStyle(button: button2)
        initButtonStyle(button: button3)

        startButton.layer.cornerRadius = 8

        effectView.effect = UIBlurEffect(style: .light)
        effectView.frame = coverImage.bounds
        coverImage.addSubview(effectView)
        
        blurBackground.effect = UIBlurEffect(style: .regular)
        blurBackground.alpha = 0.5

        resetGameplayView()
        showStartButton()
    }
    
    func setupNewGame() {
        playRound = 1
        score = 0
        scoreLabel.text = String(score)
        shuffledQuizDataIndex = Array(0...29).shuffled()
        setupNewData()
        resetGameplayView()
    }
    
    func setupNewData() {
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
        
        playRoundLabel.text = "\(playRound) / \(maxPlayRound)"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stepUnblur), userInfo: nil, repeats: true)
    }
    
    func resetGameplayView() {
        resetBlur()
        hideNextButton()
        hideYoutubeButton()
        hideStartButton()
        
        initButtonStyle(button: button1)
        initButtonStyle(button: button2)
        initButtonStyle(button: button3)
        
        pointsButton1.isHidden = true
        pointsButton2.isHidden = true
        pointsButton3.isHidden = true
    }
   
    @IBAction func button1Pressed(_ sender: UIButton) {
        evaluate(button: sender, answer: correctAnswer == 0)
        if correctAnswer == 0 {
            pointsButton1.text = "+\(10 - counter)"
            pointsButton1.fadeOut()
        }
    }
    
    @IBAction func button2Pressed(_ sender: UIButton) {
        evaluate(button: sender, answer: correctAnswer == 1)
        if correctAnswer == 1 {
            pointsButton2.text = "+\(10 - counter)"
            pointsButton2.fadeOut()
        }
    }
    
    @IBAction func button3Pressed(_ sender: UIButton) {
        evaluate(button: sender, answer: correctAnswer == 2)
        if correctAnswer == 2 && counter < 10 {
            pointsButton3.text = "+\(10 - counter)"
            pointsButton3.fadeOut()
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
        resetGameplayView()
        setupNewData()
      }

    @IBAction func homeButtonPressed(_ sender: UIButton) {
        if playRound != 0 {
            let ac = UIAlertController(title: "Music Cover Quiz", message: NSLocalizedString("Are you sure you want to cancel the current game?", comment: "CancelGame: Question"), preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "CancelGame: OK"), style: .default) { action -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            ac.addAction(UIAlertAction(title: NSLocalizedString("Back", comment: "CancelGame: Back"), style: .default))
            ac.addAction(okAction)
            present(ac, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        setupNewGame()
    }
    
    func evaluate(button: UIButton, answer correct: Bool) {
        timer?.invalidate()
        timer = nil
        unblur()
        showYoutubeButton()
        disableButtons()
        
        button.tintColor = UIColor.black
        button.layer.backgroundColor = correct ? UIColor.green.cgColor : UIColor.red.cgColor
        
        if correct && counter <= 10 {
            score += (10 - counter)
            scoreLabel.text = String(score)
        }

        if playRound == 5 {
            var inputTextField: UITextField?
            let congratulation1 = NSLocalizedString("Congratulations, you got ", comment: "UsernamePrompt: Congratulation 1")
            let congratulation2 = NSLocalizedString(" points!", comment: "UsernamePrompt: Congratulation 2")
            
            let usernamePrompt = UIAlertController(title: "Music Cover Quiz", message: congratulation1 + String(score) + congratulation2, preferredStyle: UIAlertControllerStyle.alert)
            usernamePrompt.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "UsernamePrompt: Cancel"), style: UIAlertActionStyle.default, handler: nil))
            usernamePrompt.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "UsernamePrompt: OK"), style: .default, handler: { (action) -> Void in
                // score und Spielername speichern!
                let username = (inputTextField?.text)!
                print("\(username): \(self.score)")
                let leaderBoard = LeaderboardViewController()
                leaderBoard.saveNewPlayerScore(name: username, points: self.score)
                
            }))
            usernamePrompt.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = NSLocalizedString("Username", comment: "UsernamePrompt: Username")
                inputTextField = textField
            })
            present(usernamePrompt, animated: true, completion: nil)
            playRound = 0
            showStartButton()
        } else {
            playRound += 1
            showNextButton()
        }
    }
    
    func stepUnblur() {
        if counter <= 10 {
            counter += 1
            effectView.alpha = CGFloat(alpha[counter])
            progressBar.progress = Float(10 - counter) * 0.1
        }
    }
    
    func unblur() {
        effectView.alpha = 0.0
    }
    
    func resetBlur() {
        counter = 0
        effectView.alpha = CGFloat(alpha[counter])
        progressBar.progress = Float(10 - counter) * 0.1
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
    
    func initButtonStyle(button: UIButton) {
        button.layer.cornerRadius = 8
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.titleLabel?.numberOfLines = 2
        
        button.layer.backgroundColor = blue.cgColor
        button.tintColor = UIColor.white
        button.isEnabled = true
    }
    
    func disableButtons() {
        button1.isEnabled = false
        button2.isEnabled = false
        button3.isEnabled = false
    }
}
