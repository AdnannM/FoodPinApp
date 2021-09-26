//
//  SingInViewController.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 21.09.21.
//

import UIKit
import Firebase


class SingInViewController: UIViewController {
    

    @IBOutlet weak var backgroundImage: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   
    
    @IBAction func loginUser(_ sender: UIButton) {
        // Validate User
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  showError(title: "Login Error", message: "Both filed must not be blank.")
                  return
        }
        
            loginUser(email, password)
           
    }

    
    private func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}


extension SingInViewController {
    fileprivate func loginUser(_ email: String, _ password: String) {
        var emailUser: String?
        
        if email.contains("@"), email.contains(".") {
            emailUser = email
        }
        
        Auth.auth().signIn(withEmail: emailUser!, password: password) { result, error in
            if let error = error {
                self.showError(title: "Login Error", message: error.localizedDescription)
                return
            }
            
            // Email verification
            guard let result = result, result.user.isEmailVerified else {
                
                let alert = UIAlertController(title: "Login Error", message: "You haven't confirmed your email address yet. We send you a confirmation email when you sign up.Please click the verification link in thet email. If you need us to send the confirmation email again please thap Resend Email", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Resend email", style: .default) { action in
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            // Dismiss the Keyboard
            self.view.endEditing(true)
            
            // Present View
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") {
                UIApplication.shared.keyWindow?.rootViewController = vc
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
