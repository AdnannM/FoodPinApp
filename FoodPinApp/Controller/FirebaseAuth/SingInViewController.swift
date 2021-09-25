//
//  SingInViewController.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 21.09.21.
//

import UIKit
import Firebase
import Lottie

class SingInViewController: UIViewController {
    
    let animationView = AnimationView()

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
        
        var emailUser: String?
        
        if email.contains("@"), email.contains(".") {
            emailUser = email
        }
        
        AuthManager.shared.loginUser(email: emailUser, password: password) { login in
            if login {
                self.showError(title: "Great!", message: "Successeffuly Login to FoodPin")
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showError(title: "Login Error", message: "We are unable to log you in")
            }
            
            // Dissmiss the keyboard
            self.view.endEditing(true)
        }
        
//        // Present View
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") {
//            UIApplication.shared.keyWindow?.rootViewController = vc
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    private func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func loginAnimation() {
        animationView.animation = Animation.named("data-4")
        //animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
}
