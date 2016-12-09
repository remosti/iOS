//
//  LeaderboardViewController.swift
//  Music Cover Quiz
//
//  Created by Remo Stirnimann on 04.12.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    
    
    // MARK: Properties
    let FILENAME = "leaders.xml"
    var leaderBoard : [LeaderBoardEntry] = []
    var playersName : String = ""
    var playersScore : Int = -1
    @IBOutlet weak var leaderBoardTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Background setzten
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        leaderBoardTable.delegate = self
        leaderBoardTable.dataSource = self
        
        
        // Aktuelle Rangliste aus dem File-Store
        leaderBoard = loadLeaderBoard()
        
        // Prüfen, ob ein neuer Eintrag besteht. Wenn neuer Eintrag, zu Array hinzufügen und in File speichern
        if(playersName != "" && playersScore > -1){
            leaderBoard.append(LeaderBoardEntry(name: playersName, points: playersScore))
            storeLeaderBoard()
        }
        
        leaderBoard.append(LeaderBoardEntry(name: "dummy", points: Int(arc4random_uniform(50) + 1)))
        storeLeaderBoard()
        
        leaderBoard = sortLeaderBoard(toSort: leaderBoard)
        
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
        
        var leaders : [String] = []
        
        for item in leaderBoard{
            if(item.name != "" && item.points > 0){
                leaders.append("\(item.name);\(item.points)")}
        }
        
        (leaders as NSArray).write(to: filePath, atomically: true)
        print(filePath as NSURL)
    }
    /**
     * Lesen der aktuellen Rangliste aus dem File-Store
     */
    func loadLeaderBoard() -> [LeaderBoardEntry]{
        let appPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = appPath.appendingPathComponent(FILENAME)
        let read = NSArray(contentsOf: filePath)
        print(filePath as NSURL)
        var leader : [LeaderBoardEntry] = []
        if read != nil{
            for item in read!{
                let element = (item as! NSString).components(separatedBy: ";")
                leader.append(LeaderBoardEntry(name: element[0], points: Int(element[1]) ?? 0))
            }
            return sortLeaderBoard(toSort: leader)
        }else{
            return  [LeaderBoardEntry(name:"",points: -1)]
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = leaderBoardTable.dequeueReusableCell(withIdentifier: "LeaderBoardCell", for: indexPath) as! LeaderBoardTableViewCell
        
        if(leaderBoard[indexPath.row].points > -1){
            cell.labelRang?.text = String(indexPath.row + 1)
            cell.labelName?.text = leaderBoard[indexPath.row].name
            cell.labelPunkte?.text = String(leaderBoard[indexPath.row].points)
        }else{
            cell.labelRang?.text = ""
            cell.labelName?.text = ""
            cell.labelPunkte?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(leaderBoard.count < 10){
            return leaderBoard.count
        }else{
            return 10
        }
        
        
    }
    
    func sortLeaderBoard(toSort: [LeaderBoardEntry]) -> [LeaderBoardEntry]{
        return toSort.sorted{$0.points > $1.points}
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
