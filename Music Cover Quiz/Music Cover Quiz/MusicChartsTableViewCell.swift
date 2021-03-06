//
//  MusicChartsTableViewCell.swift
//  Music Cover Quiz
//
//  Created by Valentin Schuler on 10.12.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import Foundation
import UIKit

class MusicChartsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelPosition: UILabel!
    @IBOutlet weak var labelArtist: UILabel!
    @IBOutlet weak var labelSong: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
