//
//  ThoughtCell.swift
//  Random
//
//  Created by Javier Gomez on 12/10/18.
//  Copyright © 2018 Javier Gomez. All rights reserved.
//

import UIKit
import Firebase

class ThoughtCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var numLikesLbl: UILabel!
    @IBOutlet weak var starIconImg: UIImageView!
    @IBOutlet weak var thoughtTxtLbl: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var numCommentsLbl: UILabel!
    
    
    private var thought: Thought!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        starIconImg.addGestureRecognizer(tap)
        starIconImg.isUserInteractionEnabled = true
    }
    
    @objc func likeTapped() {
        Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId)
            .updateData([NUM_LIKES: thought.numLikes + 1])
    }
    
    func configureCell(thought: Thought) {
        self.thought = thought
        
        usernameLbl.text = thought.username
        thoughtTxtLbl.text = thought.thoughtTxt
        numLikesLbl.text = String(thought.numLikes)
        numCommentsLbl.text = String(thought.numComments)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        timestampLbl.text = timestamp
    }
}
