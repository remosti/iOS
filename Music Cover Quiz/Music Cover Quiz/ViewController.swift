//
//  ViewController.swift
//  Music Cover Quiz
//
//  Created by Remo Stirnimann on 28.11.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var quizData: [QuizDataItem]?

    let alert = UIAlertController(title: nil, message: "Daten werden geladen...", preferredStyle: .alert)
    
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var showLeaderboardButton: UIButton!
    @IBOutlet weak var showChartsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        let cornerRadius : CGFloat = 8
        playGameButton.layer.cornerRadius = cornerRadius
        showLeaderboardButton.layer.cornerRadius = cornerRadius
        showChartsButton.layer.cornerRadius = cornerRadius
        
        DispatchQueue.global().async {
            if (updateQuizData()) {
                self.quizData = loadQuizDataFromFile()
            }
            DispatchQueue.main.async {
                self.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 10, width: 40, height: 40)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        self.alert.view.addSubview(loadingIndicator)
        self.present(self.alert, animated: true, completion: nil)
    }

    @IBAction func playGameButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameplayViewController = storyboard.instantiateViewController(withIdentifier: "GamePlayViewController") as! GamePlayViewController
        gameplayViewController.quizData = self.quizData
        self.present(gameplayViewController, animated: true, completion: nil)
    }
    
    @IBAction func unwindBackToMainView(segue: UIStoryboardSegue) {
    }
}

