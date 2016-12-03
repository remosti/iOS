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
    let filePath = getDocumentsDirectory().appendingPathComponent("quizdata.data")
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
    let filePath = getDocumentsDirectory().appendingPathComponent("quizdata.data")
    var loaded = false
    
    do {
        try FileManager.default.removeItem(at: filePath)
    } catch {
        print("No quiz data to delete: \(error)")
    }
    
    do {
        if let data = URL(string: googleDocsUrl) {
            let content = try String(contentsOf: data)
            // write new data
            try content.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
            // load cover images
            if let data = loadQuizDataFromFile() {
                loaded = updateCoverImages(quizData: data)
            }
        }
    } catch {
        print("Could not update quiz data: \(error)")
    }
    return loaded
}

func updateCoverImages(quizData: [QuizDataItem]) -> Bool {
    var updated = true
    for item in quizData {
        let imageUrl = item.coverImage
        if (imageUrl != "") {
            do {
                let image = try UIImage(data: NSData(contentsOf: NSURL(string: imageUrl) as! URL) as Data)
                let coverImageFilename = (imageUrl as NSString).lastPathComponent
                let filename = getDocumentsDirectory().appendingPathComponent(coverImageFilename)
                try UIImageJPEGRepresentation(image!, 100)?.write(to: filename, options: .atomic)
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

