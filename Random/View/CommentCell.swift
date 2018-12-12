//
//  CommentCell.swift
//  Random
//
//  Created by Javier Gomez on 12/12/18.
//  Copyright © 2018 Javier Gomez. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
