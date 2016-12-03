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
    var band: String
    var song: String
    var coverImage: String
    var youtubeUrl: String
    
    func getLocalCoverImage() -> UIImage? {
        var image: UIImage?
        let coverImageFilename = (coverImage as NSString).lastPathComponent
        let fileName = getDocumentsDirectory().appendingPathComponent(coverImageFilename)

   //     if FileManager.default.fileExists(atPath: fileName.absoluteString) {
            let url = NSURL(string: fileName.absoluteString)
            let data = NSData(contentsOf: url! as URL)
            image = UIImage(data: data! as Data)
   //     }
        return image
    }

}
