//
//  LeaderboardViewController.swift
//  Music Cover Quiz
//
//  Created by Remo Stirnimann on 04.12.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController{

    // MARK: Properties
    let FILENAME = "leaders.xml"
    var leaderBoard : [LeaderBoardEntry] = []
    @IBOutlet weak var leaderBoardTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Aktuelle Rangliste aus dem File-Store
        leaderBoard = loadLeaderBoard()
        
        leaderBoard.append(LeaderBoardEntry(name:"Remo",points:32))
        //leaderBoard.append("test")
        storeLeaderBoard()
        
        print(leaderBoard.count)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: FileHandling
    
    /**
     * Speichern der aktuellen Rangliste ind den File-Store
     */
    func storeLeaderBoard(){
        let appPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = appPath.appendingPathComponent(FILENAME)
        
        //if leaderBoard != nil{
            (leaderBoard as NSArray).write(to: filePath, atomically: true)
        print(appPath.appendingPathComponent(FILENAME) as NSURL	)
        //}
    }
    /**
     * Lesen der aktuellen Rangliste aus dem File-Store
     */
    func loadLeaderBoard() -> [LeaderBoardEntry]{
        let appPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = appPath.appendingPathComponent(FILENAME)
        
        let read = NSArray(contentsOf: filePath)
        
        if read != nil{
            return read as! [LeaderBoardEntry]
        }else{
            return  [LeaderBoardEntry(name:"",points:0)]
        }
    }
}

// MARK: Structur
/**
 * Datenstruktur für die Speicherung der Rangliste
 */
struct LeaderBoardEntry {
    var name : String
    var points : Int
}
