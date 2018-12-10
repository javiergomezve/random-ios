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

    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var thoughtTxt: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
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
        guard let username = usernameTxt.text else { return }
        guard let thought = thoughtTxt.text else { return }
        
        Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: [
            CATEGORY: selectedCategory,
            NUM_LIKES: 0,
            NUM_COMMENTS: 0,
            THOUGHT_TXT: thought,
            TIMESTAMP: FieldValue.serverTimestamp(),
            USERNAME: username
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
