//
//  LeaderBoardTableViewCell.swift
//  Music Cover Quiz
//
//  Created by Remo Stirnimann on 09.12.16.
//  Copyright © 2016 Remo Stirnimann. All rights reserved.
//

import UIKit

class LeaderBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var labelRang: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPunkte: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
