//
//  ViewController.swift
//  Random
//
//  Created by Javier Gomez on 12/10/18.
//  Copyright © 2018 Javier Gomez. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    private var thoughts = [Thought]()
    private var thoughtsCollectionRef: CollectionReference!
    private var thoughtsListener: ListenerRegistration!
    private var categorySelected: String = ThoughtCategory.funny.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.estimatedRowHeight = 320
//        tableView.rowHeight = UITableView.automaticDimension
        
        thoughtsCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setListener()
    }
    
    func setListener() {
        if categorySelected == ThoughtCategory.popular.rawValue {
            thoughtsListener = thoughtsCollectionRef
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener { (snapshot, err) in
                    if let err = err {
                        debugPrint("Error fetching docs: \(err)")
                    } else {
                        guard let snap = snapshot else { return }
                        
                        self.thoughts = []
                        
                        for document in snap.documents {
                            let data = document.data()
                            let username = data[USERNAME] as? String ?? "Anonymous"
                            let timestamp = data[TIMESTAMP] as? Date ?? Date()
                            let thoughtTxt = data[THOUGHT_TXT] as? String ?? "thoughtTxt"
                            let numLikes = data[NUM_LIKES] as? Int ?? 0
                            let numComments = data[NUM_COMMENTS] as? Int ?? 0
                            let documentId = document.documentID
                            
                            let newTought = Thought(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentId)
                            
                            self.thoughts.append(newTought)
                        }
                        
                        self.tableView.reloadData()
                    }
            }
        } else {
            thoughtsListener = thoughtsCollectionRef
                .whereField(CATEGORY, isEqualTo: categorySelected)
                .order(by: TIMESTAMP, descending: true)
                .addSnapshotListener { (snapshot, err) in
                    if let err = err {
                        debugPrint("Error fetching docs: \(err)")
                    } else {
                        guard let snap = snapshot else { return }
                        
                        self.thoughts = []
                        
                        for document in snap.documents {
                            let data = document.data()
                            let username = data[USERNAME] as? String ?? "Anonymous"
                            let timestamp = data[TIMESTAMP] as? Date ?? Date()
                            let thoughtTxt = data[THOUGHT_TXT] as? String ?? "thoughtTxt"
                            let numLikes = data[NUM_LIKES] as? Int ?? 0
                            let numComments = data[NUM_COMMENTS] as? Int ?? 0
                            let documentId = document.documentID
                            
                            let newTought = Thought(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentId)
                            
                            self.thoughts.append(newTought)
                        }
                        
                        self.tableView.reloadData()
                    }
            }
        }
    }
    func addThought(thought: Thought) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        thoughtsListener.remove()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughts[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
            case 0:
                categorySelected = ThoughtCategory.funny.rawValue
            case 1:
                categorySelected = ThoughtCategory.serious.rawValue
            case 2:
                categorySelected = ThoughtCategory.crazy.rawValue
            default:
                categorySelected = ThoughtCategory.popular.rawValue
        }
        
        thoughtsListener.remove()
        
        setListener()
    }
}

