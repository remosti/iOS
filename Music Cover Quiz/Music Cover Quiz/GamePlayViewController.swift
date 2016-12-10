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
        shuffledQuizDataIndex = Array(0...19).shuffled()
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
        
        button1.layer.backgroundColor = blue.cgColor
        button2.layer.backgroundColor = blue.cgColor
        button3.layer.backgroundColor = blue.cgColor
        
        button1.tintColor = UIColor.white
        button2.tintColor = UIColor.white
        button3.tintColor = UIColor.white
        
        button1.isEnabled = true
        button2.isEnabled = true
        button3.isEnabled = true
        
        pointsButton1.isHidden = true
        pointsButton2.isHidden = true
        pointsButton3.isHidden = true
    }
   
    @IBAction func button1Pressed(_ sender: UIButton) {
        evaluate(answer: correctAnswer == 0)
        button1.tintColor = UIColor.black
        button1.layer.backgroundColor = (correctAnswer == 0) ? UIColor.green.cgColor : UIColor.red.cgColor
        disableButtons()
        pointsButton1.fadeOut()
    }
    
    @IBAction func button2Pressed(_ sender: UIButton) {
        showYoutubeButton()
        evaluate(answer: correctAnswer == 1)
        button2.tintColor = UIColor.black
        button2.layer.backgroundColor = (correctAnswer == 1) ? UIColor.green.cgColor : UIColor.red.cgColor
        disableButtons()
        pointsButton2.fadeOut()
    }
    
    @IBAction func button3Pressed(_ sender: UIButton) {
        showYoutubeButton()
        evaluate(answer: correctAnswer == 2)
        button3.tintColor = UIColor.black
        button3.layer.backgroundColor = (correctAnswer == 2) ? UIColor.green.cgColor : UIColor.red.cgColor
        disableButtons()
        pointsButton3.fadeOut()
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
            let ac = UIAlertController(title: "Music Cover Quiz", message: "Wollen Sie das aktuelle Spiel wirklich abbrechen?", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            ac.addAction(UIAlertAction(title: "Zurück", style: .default))
            ac.addAction(okAction)
            present(ac, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        setupNewGame()
    }
    
    func evaluate(answer correct: Bool) {
        timer?.invalidate()
        timer = nil
        unblur()
        showYoutubeButton()
        
        if correct && counter <= 10 {
            score += (10 - counter)
            scoreLabel.text = String(score)
        }

        if playRound == 5 {
            var inputTextField: UITextField?
            let usernamePrompt = UIAlertController(title: "Music Cover Quiz", message: "Gratulation, Sie haben \(score) Punkte erspielt!", preferredStyle: UIAlertControllerStyle.alert)
            usernamePrompt.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertActionStyle.default, handler: nil))
            usernamePrompt.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                // score und Spielername speichern!
                let username = (inputTextField?.text)!
                print("\(username): \(self.score)")
            }))
            usernamePrompt.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Spielername"
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
        print(counter)
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
    
    func disableButtons() {
        button1.isEnabled = false
        button2.isEnabled = false
        button3.isEnabled = false
    }
}
