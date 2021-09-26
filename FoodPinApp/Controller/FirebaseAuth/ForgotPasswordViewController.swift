//
//  ForgotPasswordViewController.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 21.09.21.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    @IBAction func resetPassword(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Input Error", message: "Please provide your email address for password reset")
            return
        }
        
        // Send password reset mail
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            let title = (error == nil) ? "Password Reset Folow-up" : "Password Reset Error"
            let message = (error == nil) ? "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password" : error?.localizedDescription
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { action in
                if error == nil {
                    // Dismiss keyboard
                    self.view.endEditing(true)
                    
                    // Return to the login Screen
                    if let navVC = self.navigationController {
                        navVC.popToRootViewController(animated: true)
                    }
                }
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
