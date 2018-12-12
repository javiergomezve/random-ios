//
//  CommentsVc.swift
//  Random
//
//  Created by Javier Gomez on 12/12/18.
//  Copyright © 2018 Javier Gomez. All rights reserved.
//

import UIKit

class CommentsVc: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCommentTxt: NSLayoutConstraint!
    @IBOutlet weak var keyboardView: UIView!
    
    
    var thought: Thought!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addCommentTapped(_ sender: Any) {
    }
}
