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
       
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "LaunchViewBackground")!)
        
        playGameButton.layer.cornerRadius = cornerRadius
        showLeaderboardButton.layer.cornerRadius = cornerRadius
        showChartsButton.layer.cornerRadius = cornerRadius
        // Do any additional setup after loading the view, typically from a nib.
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

