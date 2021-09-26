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
    
    enum Resigration {
        case name
        case password
        case email
    }
    
    // View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Action
    @IBAction func createAccount(_ sender: UIButton) {
        nameTextField.becomeFirstResponder()
        emailTextField.becomeFirstResponder()
        passwordTextField.becomeFirstResponder()
        
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  showAlert(title: "Restrations Error",
                            message: "Please make sure you provide your name, email address and password to complete registration")
                  return
              }
        
        // Register user account on Firebase
        AuthManager.shared.registerUser(name: name, email: email, password: password) { register in
            DispatchQueue.main.async {
                if register {
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") {
                        UIApplication.shared.keyWindow?.rootViewController = vc
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.showAlert(title: "Resistration Error", message: "Failed to Create Account Please try Again!")
                    return
                }
            }
            
            // Save the neme of the user
            AuthManager.shared.saveUserName(name: name) { error in
                if let error = error {
                    self.showAlert(title: "Failed to change display name", message: "\(error.localizedDescription)")
                }
                
                // Dissmis the keyboard
                self.view.endEditing(true)
        }
    }
}
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

