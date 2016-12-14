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

    // MARK: Properties
    let fileName = "charts.xml"
    var charts: [MusicChartsEntry] = []
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

        // Aktuelle Rangliste aus dem File-Store
        charts = loadCharts()
        
        // Prüfen, ob ein neuer Eintrag besteht. Wenn neuer Eintrag, zu Array hinzufügen und in File speichern
        if(position > 0 && artistName != "" && songName != "") {
            charts.append(MusicChartsEntry(position: position, artist: artistName, song: songName))
            storeCharts()
        }
        
        charts.append(MusicChartsEntry(position: 1, artist: "Artist", song: "Song"))
        storeCharts()
        
        charts = sortCcharts(toSort: charts)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: FileHandling
    
    /**
     * Speichern der aktuellen Charts ind den File-Store
     */
    func storeCharts(){
        let appPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = appPath.appendingPathComponent(fileName)
        
        var entries : [String] = []
        
        for item in charts {
            if(item.position > 0 && item.artist != "" && item.song != "") {
                entries.append("\(item.position);\(item.artist); \(item.song)")}
        }
        
        (entries as NSArray).write(to: filePath, atomically: true)
        print(filePath as NSURL)
    }
    /**
     * Lesen der aktuellen Charts aus dem File-Store
     */
    func loadCharts() -> [MusicChartsEntry]{
        let appPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = appPath.appendingPathComponent(fileName)
        let read = NSArray(contentsOf: filePath)
        print(filePath as NSURL)
        var chartsEntries : [MusicChartsEntry] = []
        if read != nil{
            for item in read!{
                let element = (item as! NSString).components(separatedBy: ";")
                chartsEntries.append(MusicChartsEntry(position: Int(element[0])!, artist: element[1], song: element[2]))
            }
            return sortCharts(toSort: chartsEntries)
        } else {
            return  [MusicChartsEntry(position: -1, artist: "", song: "")]
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chartsTable.dequeueReusableCell(withIdentifier: "MusicChartsCell", for: indexPath) as! MusicChartsTableViewCell
        
        if(charts[indexPath.row].position > -1) {
            cell.labelPosition?.text = String(indexPath.row + 1)
            cell.labelSong?.text = charts[indexPath.row].song
            cell.labelArtist?.text = String(charts[indexPath.row].artist)
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
    
    func sortCharts(toSort: [MusicChartsEntry]) -> [MusicChartsEntry]{
        return toSort.sorted{$0.position > $1.position}
    }
    
}

// MARK: Structur
/**
 * Datenstruktur für die Speicherung der Charts
 */
struct MusicChartsEntry {
    var position: Int
    var artist: String
    var song: String
    var image: UIImage
}
