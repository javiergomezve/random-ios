//
//  LoginVC.swift
//  Random
//
//  Created by Javier Gomez on 12/11/18.
//  Copyright © 2018 Javier Gomez. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var createUserBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = 10
        createUserBtn.layer.cornerRadius = 10
    }
    
    
    @IBAction func loginBtnTapped(_ sender: Any) {
    }
    
    @IBAction func createUserBtnTapped(_ sender: Any) {
        
    }
}
