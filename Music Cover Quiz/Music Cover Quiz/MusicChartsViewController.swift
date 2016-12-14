//
//  MusicChartsViewController.swift
//  Music Cover Quiz
//
//  Created by Valentin Schuler on 10.12.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import Foundation
import UIKit

class MusicChartsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{

    var charts: [QuizDataItem] = []
    var position: Int = 0
    var artistName: String = ""
    var songName: String = ""
    
    @IBOutlet weak var chartsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Background setzten
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        chartsTable.delegate = self
        chartsTable.dataSource = self

        charts = loadQuizDataFromFile()!
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chartsTable.dequeueReusableCell(withIdentifier: "MusicChartsCell", for: indexPath) as! MusicChartsTableViewCell
        
        if(charts[indexPath.row].ranking > 0) {
            cell.labelPosition?.text = String(indexPath.row + 1)
            cell.labelSong?.text = charts[indexPath.row].song
            cell.labelArtist?.text = String(charts[indexPath.row].band)
            cell.coverImage?.image = charts[indexPath.row].getLocalCoverImage()
        } else {
            cell.labelPosition?.text = ""
            cell.labelArtist?.text = ""
            cell.labelSong?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charts.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: charts[indexPath.row].youtube) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
