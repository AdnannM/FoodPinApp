//
//  WelcomeViewController.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 21.09.21.
//

import UIKit
import Lottie
import DeviceKit

class WelcomeViewController: UIViewController {

    let animationView = AnimationView()
    @IBOutlet weak var backgroundView: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimations()
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
}
