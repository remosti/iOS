//
//  MusicChartsParser.swift
//  Music Cover Quiz
//
//  Created by Valentin Schuler on 28.11.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import Foundation

func loadQuizDataFromFile() -> [QuizDataItem]? {
    var quizData: [QuizDataItem] = [QuizDataItem]()
    let appPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = appPath.appendingPathComponent("quiz.xml")
    do {
        let content = try String(contentsOf: filePath, encoding: String.Encoding.utf8)
        let csv = CSwiftV(with: content)
        for row in csv.rows {
            let item = QuizDataItem(band: row[2], song: row[3], coverImage: row[4], youtubeUrl: row[5])
            quizData.append(item)
        }
    } catch {
        print("Could not load quiz data: \(error)")
    }
    
    return quizData
}


func updateQuizData() -> Bool {
    let url = "https://docs.google.com/spreadsheets/d/e/2PACX-1vRQPm1zu6hsYP1GPjKaxmSeEGV75EcANvo7ktl963vNt-ozLmWKopkRHMp2EIl-eOKP9UzDUj6v4wmM/pub?gid=0&single=true&output=csv"
    let appPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = appPath.appendingPathComponent("quiz.xml")
    
    var loaded = false
    do {
        if let data = URL(string: url) {
            let content = try String(contentsOf: data)
            // delete old data
            try FileManager.default.removeItem(at: filePath)
            // write new data
            try content.write(to: filePath, atomically: false, encoding: String.Encoding.utf8)
            loaded = true
        }
    } catch {
        print("Could not update quiz data: \(error)")
    }
    return loaded
}

