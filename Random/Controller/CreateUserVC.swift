//
//  CreateUserVC.swift
//  Random
//
//  Created by Javier Gomez on 12/11/18.
//  Copyright © 2018 Javier Gomez. All rights reserved.
//

import UIKit

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
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
    }
}
