//
//  ProfileViewController.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 21.09.21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Profile"
        if let currentUser = Auth.auth().currentUser {
            nameLabel.text = currentUser.displayName
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
        }
        catch {
            showError(title: "Logout Error", message: "Logout Timeout please try Again.")
            return
        }
        
        // Present View
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") {
            UIApplication.shared.keyWindow?.rootViewController = vc
            self.dismiss(animated: true, completion: nil)
        }
    }
    private func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
