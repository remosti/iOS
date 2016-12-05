//
//  MusicChartsParser.swift
//  Music Cover Quiz
//
//  Created by Valentin Schuler on 28.11.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import Foundation
import UIKit

let googleDocsUrl = "https://docs.google.com/spreadsheets/d/e/2PACX-1vRQPm1zu6hsYP1GPjKaxmSeEGV75EcANvo7ktl963vNt-ozLmWKopkRHMp2EIl-eOKP9UzDUj6v4wmM/pub?gid=0&single=true&output=csv"

func loadQuizDataFromFile() -> [QuizDataItem]? {
    var quizData: [QuizDataItem] = [QuizDataItem]()
    let fileUrl = getDocumentsDirectory().appendingPathComponent("quizdata.data")
    do {
        let content = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8)
        let csv = CSwiftV(with: content)
        for row in csv.rows {
            let item = QuizDataItem(ranking: Int(row[1])!, band: row[2], song: row[3], coverImage: row[4], youtube: row[5])
            quizData.append(item)
        }
    } catch {
        print("Could not load quiz data: \(error)")
    }
    return quizData
}

func updateQuizData() -> Bool {
    let fileUrl = getDocumentsDirectory().appendingPathComponent("quizdata.data")
    
    do {
        try FileManager.default.removeItem(at: fileUrl)
    } catch {
        print("No quiz data deleted: \(error)")
    }
    
    do {
        if let data = URL(string: googleDocsUrl) {
            let content = try String(contentsOf: data)
            try content.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
            if let data = loadQuizDataFromFile() {
                return updateCoverImages(quizData: data)
            } else {
                return false
            }
        } else {
            return false
        }
    } catch {
        print("Could not update quiz data: \(error)")
        return false
    }
}

func updateCoverImages(quizData: [QuizDataItem]) -> Bool {
    var updated = true
    for item in quizData {
        let imageUrl = item.coverImage
        if (imageUrl != "") {
            do {
                let fileName = (imageUrl as NSString).lastPathComponent
                let fileUrl = getDocumentsDirectory().appendingPathComponent(fileName)
                if !FileManager.default.fileExists(atPath: fileUrl.path) {
                    let imageData = try NSData(contentsOf: NSURL(string: imageUrl) as! URL) as Data
                    let image = UIImage(data: imageData as Data)
                    try UIImageJPEGRepresentation(image!, 100)?.write(to: fileUrl, options: .atomic)
                }
            } catch {
                updated = false
                print("Could not update image data: \(error)")
            }
        }
    }
    return updated
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths.first!
    return documentsDirectory
}

