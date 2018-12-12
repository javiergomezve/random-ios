//
//  CreateUserVC.swift
//  Random
//
//  Created by Javier Gomez on 12/11/18.
//  Copyright © 2018 Javier Gomez. All rights reserved.
//

import UIKit
import Firebase

class CreateUserVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var createUserBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUserBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
    }
    
    @IBAction func createUserTapped(_ sender: Any) {
        guard let email = emailTxt.text,
            let password = passwordTxt.text,
            let username = usernameTxt.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let error = err {
                debugPrint("Error creating user \(error.localizedDescription)")
            }
            let currentUser = Auth.auth().currentUser
            let changeRequest = currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges{ (error) in
                if let error = error {
                    debugPrint("Error updating profile: \(error.localizedDescription)")
                }
                
                guard let userId = currentUser?.uid else { return }
                Firestore.firestore().collection(USERS_REF).document(userId)
                .setData([
                    USERNAME: username,
                    DATE_CREATED: FieldValue.serverTimestamp()
                    ], completion: {(error) in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                })
            }
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
