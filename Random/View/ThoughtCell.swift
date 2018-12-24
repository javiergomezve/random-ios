//
//  ThoughtCell.swift
//  Random
//
//  Created by Javier Gomez on 12/10/18.
//  Copyright © 2018 Javier Gomez. All rights reserved.
//

import UIKit
import Firebase

protocol ThoughtDelegate {
    func thoughtOptionsTapped(thought: Thought)
}

class ThoughtCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var numLikesLbl: UILabel!
    @IBOutlet weak var starIconImg: UIImageView!
    @IBOutlet weak var thoughtTxtLbl: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!
    @IBOutlet weak var numCommentsLbl: UILabel!
    @IBOutlet weak var optionsMenu: UIImageView!
    
    
    private var thought: Thought!
    private var delegate: ThoughtDelegate!
    
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
    
    func configureCell(thought: Thought, delegate: ThoughtDelegate?) {
        optionsMenu.isHidden = true
        
        self.thought = thought
        self.delegate = delegate
        
        usernameLbl.text = thought.username
        thoughtTxtLbl.text = thought.thoughtTxt
        numLikesLbl.text = String(thought.numLikes)
        numCommentsLbl.text = String(thought.numComments)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        timestampLbl.text = timestamp
        
        if thought.userId == Auth.auth().currentUser?.uid {
            optionsMenu.isHidden = false
            optionsMenu.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(thoughtOptionsTapped))
            
            optionsMenu.addGestureRecognizer(tap)
        }
    }
    
    @objc func thoughtOptionsTapped() {
        delegate?.thoughtOptionsTapped(thought: thought)
    }
}
