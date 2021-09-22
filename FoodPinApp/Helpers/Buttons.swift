//
//  Buttons.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 21.09.21.
//

import UIKit

@IBDesignable
class Buttons: UIButton {

    @IBInspectable var cornerRaidus: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRaidus
            layer.masksToBounds = cornerRaidus > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // Text in Button
    @IBInspectable var titleLeftPadding: Double = 0.0 {
        didSet {
            titleEdgeInsets.left = CGFloat(titleLeftPadding)
        }
    }
    
    @IBInspectable var titleRightPadding: Double = 0.0 {
        didSet {
            titleEdgeInsets.right = CGFloat(titleRightPadding)
            print(titleRightPadding)
        }
    }
    
    @IBInspectable var titleTopPadding: Double = 0.0 {
        didSet {
            titleEdgeInsets.top = CGFloat(titleTopPadding)
        }
    }
    
    @IBInspectable var titleBottomPadding: Double = 0.0 {
        didSet {
            titleEdgeInsets.bottom = CGFloat(titleBottomPadding)
        }
    }
    
    // Image in Button
    @IBInspectable var imagePaddingLeft: CGFloat = 0.0 {
        didSet {
            imageEdgeInsets.left = self.bounds.width - (imageView?.bounds.width)! - imagePaddingRight
        }
    }
    
    @IBInspectable var imagePaddingRight: CGFloat = 0.0 {
        didSet {
            imageEdgeInsets.right = imagePaddingRight
        }
    }
    
    @IBInspectable var imagePaddingTop: CGFloat = 0.0 {
        didSet {
            imageEdgeInsets.top = imagePaddingTop
        }
    }
    
    @IBInspectable var imagePaddingBottom: CGFloat = 0.0 {
        didSet {
            imageEdgeInsets.bottom = imagePaddingBottom
        }
    }
    
    // Image insite Button Left or Right side
    @IBInspectable var enableImageLeftRightAligment: Bool = false
    
    // Style Button GradiantColor
    @IBInspectable var enableGradiantColor: Bool = false
    @IBInspectable var gradintColor1: UIColor = .white
    @IBInspectable var gradiantColor2: UIColor = .black
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if enableImageLeftRightAligment, let imageView = imageView {
            imageEdgeInsets.left = self.bounds.width - imageView.bounds.width - imagePaddingLeft
        }
        
        // Gradiant
        if enableGradiantColor {
            let gradiantLayer = CAGradientLayer()
            gradiantLayer.frame = self.bounds
            gradiantLayer.colors = [gradintColor1.cgColor, gradiantColor2.cgColor]
            
            gradiantLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradiantLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
            self.layer.insertSublayer(gradiantLayer, at: 0)
        }
    }
}
