//
//  ViewController.swift
//  Music Cover Quiz
//
//  Created by Remo Stirnimann on 28.11.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cornerRadius : CGFloat = 8
    
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var showLeaderboardButton: UIButton!
    @IBOutlet weak var showChartsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        playGameButton.layer.cornerRadius = cornerRadius
        showLeaderboardButton.layer.cornerRadius = cornerRadius
        showChartsButton.layer.cornerRadius = cornerRadius
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playGameButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func unwindBackToMainView(segue: UIStoryboardSegue) {
    }
}

