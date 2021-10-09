//
//  WelcomeViewController.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 21.09.21.
//

import UIKit
import Lottie
import DeviceKit
import GoogleSignIn
import FirebaseAuth

class WelcomeViewController: UIViewController {

    let animationView = AnimationView()
    @IBOutlet weak var backgroundView: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimations()
        configureDelegate()
    }
        
    @IBAction func unswindToWelcomeView(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Animations on Iphones
extension WelcomeViewController {
    private func setupAnimations() {
        
        let device = Device.current
        
       // let gouard: [Device] = [simulator.iPhone11, simulator.iPhone12, simulator.iPhone13]
        
        switch device {
        case .simulator(.iPhoneSE2):
            animationView.frame = CGRect(x: 100, y: 170, width: 200, height: 200)
        case .simulator(.iPhone6):
            animationView.frame = CGRect(x: 100, y: 170, width: 200, height: 200)
        case .simulator(.iPhone7):
            animationView.frame = CGRect(x: 100, y: 170, width: 200, height: 200)
        case .simulator(.iPhone8):
            animationView.frame = CGRect(x: 100, y: 170, width: 200, height: 200)
        case .simulator(.iPhone13ProMax):
            animationView.frame = CGRect(x: 10, y: 180, width: 400, height: 400)
        case .simulator(.iPhone13Mini):
            animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            animationView.center = view.center
        case .simulator(.iPhone13Pro):
            animationView.frame = CGRect(x: 0, y: 180, width: 400, height: 400)
        case .simulator(.iPhone13):
            animationView.frame = CGRect(x: 0, y: 180, width: 400, height: 400)
        case .simulator(.iPhone12ProMax):
            animationView.frame = CGRect(x: 10, y: 180, width: 400, height: 400)
        case .simulator(.iPhone12Mini):
            animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            animationView.center = view.center
        case .simulator(.iPhone12Pro):
            animationView.frame = CGRect(x: 0, y: 180, width: 400, height: 400)
        case .simulator(.iPhone12):
            animationView.frame = CGRect(x: 0, y: 180, width: 400, height: 400)
        case .simulator(.iPhone11ProMax):
            animationView.frame = CGRect(x: 10, y: 180, width: 400, height: 400)
            animationView.center = view.center
        case .simulator(.iPhone11Pro):
            animationView.frame = CGRect(x: 0, y: 180, width: 400, height: 400)
        case .simulator(.iPhone11):
            animationView.frame = CGRect(x: 0, y: 180, width: 400, height: 400)
        case .simulator(.iPhoneX):
            animationView.frame = CGRect(x: 0, y: 180, width: 400, height: 400)
        case .simulator(.iPhoneXR):
            animationView.frame = CGRect(x: 10, y: 180, width: 400, height: 400)
            animationView.center = view.center
        case .simulator(.iPhoneXS):
            animationView.frame = CGRect(x: 0, y: 180, width: 400, height: 400)
        case .simulator(.iPhoneXSMax):
            animationView.frame = CGRect(x: 0, y: 180, width: 400, height: 400)
        default:
            break
        }
        
        animationView.animation = Animation.named("data")
        //animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        backgroundView.addSubview(animationView)
    }
    
    // Configure GID
    private func configureDelegate() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    // MARK: - Action SingIn With google
    
    @IBAction func singInWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
}

extension WelcomeViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                         accessToken: authentication.accessToken)
        
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error",
                                                        message: error.localizedDescription,
                                                        preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            // Present main View
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                UIApplication.shared.keyWindow?.rootViewController = vc
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
