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
        
        // Validate the input
         guard let name = nameTextField.text, name != "",
             let emailAddress = emailTextField.text, emailAddress != "",
             let password = passwordTextField.text, password != "" else {
                 
                 let alertController = UIAlertController(title: "Registration Error", message: "Please make sure you provide your name, email address and password to complete the registration.", preferredStyle: .alert)
                 let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                 alertController.addAction(okayAction)
                 present(alertController, animated: true, completion: nil)
                 
                 return
         }
         
         // Register the user account on Firebase
         Auth.auth().createUser(withEmail: emailAddress, password: password, completion: { (user, error) in
             
             if let error = error {
                 let alertController = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert)
                 let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                 alertController.addAction(okayAction)
                 self.present(alertController, animated: true, completion: nil)
                 
                 return
             }
             
             // Save the name of the user
             if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                 changeRequest.displayName = name
                 changeRequest.commitChanges(completion: { (error) in
                     if let error = error {
                         print("Failed to change the display name: \(error.localizedDescription)")
                     }
                 })
             }
             
             // Dismiss keyboard
             self.view.endEditing(true)
             
             // Send verification email
             Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                     print("Failed to send verification email")
                 })
             
             let alertController = UIAlertController(title: "Email Verification", message: "We've just sent a confirmation email to your email address. Please check your inbox and click the verification link in that email to complete the sign up.", preferredStyle: .alert)
             let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                 // Dismiss the current view controller
                 self.dismiss(animated: true, completion: nil)
             })
             alertController.addAction(okayAction)
             self.present(alertController, animated: true, completion: nil)
             
         })
    }
    
    public func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

