//
//  GamePlayViewController.swift
//  Music Cover Quiz
//
//  Created by Valentin Schuler on 01.12.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController {
    
    var CorrectAnswer = String()
    var randomQuizData:[Int] = [1, 2, 3, 4, 5]
    
    var quizData: [QuizDataItem]?
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var labelEnd: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var loadedLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        let cornerRadius : CGFloat = 5
        button1.layer.cornerRadius = cornerRadius
        button2.layer.cornerRadius = cornerRadius
        button3.layer.cornerRadius = cornerRadius
        
        loadedLabel.isHidden = true
        
        let loaded = updateQuizData()
        quizData = loadQuizDataFromFile()
        
        if (loaded) {
            loadedLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.loadedLabel.isHidden = true
            })
        }
        
        hideNextButton()
        randomCovers()
    }
    
    func randomCovers () {
        
        if let data = quizData?[0] {
            if let image = data.getLocalCoverImage() {
                coverImage.image = image
                button1.setTitle ("\(data.band) - \(data.song)", for: UIControlState.normal)
            }
        }
 /*
        
        let randomIndex = Int(arc4random_uniform(UInt32(randomQuizData.count)))
        
        if randomQuizData.count > 0 {
            
            switch (randomQuizData[randomIndex]) {
                
            case 1:
                questionLabel.text = "Hola familia, Cual es mi nombre? "
                button1.setTitle ("Cesar", for: UIControlState.normal)
                button2.setTitle ("Karlos", for: UIControlState.normal)
                button3.setTitle ("William", for: UIControlState.normal)
                CorrectAnswer = "2"
                break
                
            case 2:
                questionLabel.text = "Hola famili, cual es mi apellido? "
                button1.setTitle ("Perez", for: UIControlState.normal)
                button2.setTitle ("Carvajal", for: UIControlState.normal)
                button3.setTitle ("Garcia", for: UIControlState.normal)
                CorrectAnswer = "1"
                break
                
            case 3:
                questionLabel.text = "Quien hace la lachona mas rica? "
                button1.setTitle ("Willy", for: UIControlState.normal)
                button2.setTitle ("Mario", for: UIControlState.normal)
                button3.setTitle ("Karlos", for: UIControlState.normal)
                CorrectAnswer = "1"
                break
                
            case 4:
                questionLabel.text = "Quien hace las tartas mas lindas"
                button1.setTitle ("Jili", for: UIControlState.normal)
                button2.setTitle ("Carvajal", for: UIControlState.normal)
                button3.setTitle ("Garcia", for: UIControlState.normal)
                CorrectAnswer = "4"
                break
                
            default:
                break
                
            }
            randomQuizData.remove(at: randomIndex)
        }
 */
    }
    
    @IBAction func button1Pressed(_ sender: UIButton) {
        showNextButton()
        if (CorrectAnswer == "1") {
            labelEnd.text = "Correcto"
        } else{
            labelEnd.text = "Falso"
        }
    }
    
    @IBAction func button2Pressed(_ sender: UIButton) {
        showNextButton()
        if (CorrectAnswer == "2") {
            labelEnd.text = "Correcto"
        } else{
            labelEnd.text = "Falso"
        }
    }
    
    @IBAction func button3Pressed(_ sender: UIButton) {
        showNextButton()
        if (CorrectAnswer == "3") {
            labelEnd.text = "Correcto"
        } else{
            labelEnd.text = "Falso"
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        randomCovers()
    }
    
    func hideNextButton () {
        nextButton.isHidden = true
    }
    
    func showNextButton () {
        nextButton.isHidden = false
    }
    
   
}
