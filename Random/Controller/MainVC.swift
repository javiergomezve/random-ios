//
//  ViewController.swift
//  Random
//
//  Created by Javier Gomez on 12/10/18.
//  Copyright © 2018 Javier Gomez. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ThoughtDelegate {

    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    private var thoughts = [Thought]()
    private var thoughtsCollectionRef: CollectionReference!
    private var thoughtsListener: ListenerRegistration!
    private var categorySelected: String = ThoughtCategory.funny.rawValue
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.estimatedRowHeight = 320
//        tableView.rowHeight = UITableView.automaticDimension
        
        thoughtsCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
            } else {
                self.setListener()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if thoughtsListener != nil {
            thoughtsListener.remove()
        }
    }
    
    func setListener() {
        if categorySelected == ThoughtCategory.popular.rawValue {
            thoughtsListener = thoughtsCollectionRef
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener { (snapshot, err) in
                    if let err = err {
                        debugPrint("Error fetching docs: \(err)")
                    } else {
                        self.thoughts = Thought.parseData(snapshot: snapshot)
                        
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
                        self.thoughts = Thought.parseData(snapshot: snapshot)
                        
                        self.tableView.reloadData()
                    }
            }
        }
    }
    func addThought(thought: Thought) {
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughts[indexPath.row], delegate: self)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toComments", sender: thoughts[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            if let destinationVC = segue.destination as? CommentsVc {
                if let thought = sender as? Thought {
                    destinationVC.thought = thought
                }
            }
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
    
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out: \(signoutError)")
        }
    }
    
    func thoughtOptionsTapped(thought: Thought) {
        let alert = UIAlertController(title: "Delete", message: "Delete thoought", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete thought", style: .default) { (action) in
            
            self.delete(collection: Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId).collection(COMMENTS_REF), completion: { (error) in
                if let error = error {
                    debugPrint("Could not delete thought: \(error.localizedDescription)")
                } else {
                    Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId)
                        .delete(completion: { (error) in
                            if let error = error {
                                debugPrint("Could not delete thought: \(error.localizedDescription)")
                            } else {
                                alert.dismiss(animated: true, completion: nil)
                            }
                        })
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func delete(collection: CollectionReference, batchSize: Int = 100, completion: @escaping (Error?) -> ()) {
        collection.limit(to: batchSize).getDocuments { (docset, error) in
            guard let docset = docset else {
                completion(error)
                return
            }
            
            guard docset.count > 0 else {
                completion(nil)
                return
            }
            
            let batch = collection.firestore.batch()
            docset.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { (batchError) in
                if let batchError = batchError {
                    completion(batchError)
                } else {
                    self.delete(collection: collection, batchSize: batchSize, completion: completion)
                }
            }
        }
    }
}

