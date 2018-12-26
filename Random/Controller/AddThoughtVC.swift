//
//  AddThoughtVC.swift
//  Random
//
//  Created by Javier Gomez on 12/10/18.
//  Copyright © 2018 Javier Gomez. All rights reserved.
//

import UIKit
import Firebase

class AddThoughtVC: UIViewController, UITextViewDelegate {

    @IBOutlet private weak var categorySegment: UISegmentedControl!
    @IBOutlet private weak var thoughtTxt: UITextView!
    @IBOutlet private weak var postBtn: UIButton!
    
    private var selectedCategory = ThoughtCategory.funny.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postBtn.layer.cornerRadius = 4
        thoughtTxt.layer.cornerRadius = 4
        thoughtTxt.text = "My random thought..."
        thoughtTxt.textColor = UIColor.lightGray
        thoughtTxt.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGray
    }

    @IBAction func postBtnTapped(_ sender: Any) {
        guard let thought = thoughtTxt.text else { return }
        
        Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: [
            CATEGORY: selectedCategory,
            NUM_LIKES: 0,
            NUM_COMMENTS: 0,
            THOUGHT_TXT: thought,
            TIMESTAMP: FieldValue.serverTimestamp(),
            USERNAME: Auth.auth().currentUser?.displayName ?? "",
            USER_ID: Auth.auth().currentUser?.uid ?? ""
            ], completion:{ (err) in
                if let err = err {
                    debugPrint("Error adding document \(err)")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
        })
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.funny.rawValue
        }
    }
}
