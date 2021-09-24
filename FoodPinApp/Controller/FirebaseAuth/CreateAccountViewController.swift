//
//  CreateAccountViewController.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 21.09.21.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Action
    @IBAction func registerAccount(_ sender: UIButton) {
        // Validate Input
        guard let name = nameTextField.text, name != "",
              let email = emailTextField.text, email != "",
              let password = passwordTextField.text, password != ""
        else {
              return
        }
        
        // 
        AuthManager.shared.registerUser(name: name, email: email, password: password)
    }
}
