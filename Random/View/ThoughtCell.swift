//
//  ThoughtCell.swift
//  Random
//
//  Created by Javier Gomez on 12/10/18.
//  Copyright © 2018 Javier Gomez. All rights reserved.
//

import UIKit

class ThoughtCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var numLikesLbl: UILabel!
    @IBOutlet weak var starIconImg: UIImageView!
    @IBOutlet weak var thoughtTxtLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(thought: Thought) {
        usernameLbl.text = thought.username
        thoughtTxtLbl.text = thought.thoughtTxt
        numLikesLbl.text = String(thought.numLikes)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        timestampLbl.text = timestamp
    }
}
