//
//  QuizGameplay.swift
//  Music Cover Quiz
//
//  Created by Valentin Schuler on 01.12.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import Foundation
import UIKit

struct QuizDataItem {
    var ranking: Int
    var band: String
    var song: String
    var cover: String
    var youtube: String
    
    func getLocalCoverImage() -> UIImage? {
        var image: UIImage?
        let fileName = (cover as NSString).lastPathComponent
        let fileUrl = getDocumentsDirectory().appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileUrl.path) {
            let data = NSData(contentsOf: fileUrl)
            image = UIImage(data: data! as Data)
        }
        return image
    }
}
