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
    @IBInspectable var titlePaddingLeft: CGFloat = 0.0 {
        didSet {
            titleEdgeInsets.left = titlePaddingLeft
        }
    }
    
    @IBInspectable var titlePaddingRight: CGFloat = 0.0 {
        didSet {
            titleEdgeInsets.right = titlePaddingRight
        }
    }
    
    @IBInspectable var titlePaddingTop: CGFloat = 0.0 {
        didSet {
            titleEdgeInsets.top = titlePaddingTop
        }
    }
    
    @IBInspectable var titlePaddingBottom: CGFloat = 0.0 {
        didSet {
            titleEdgeInsets.bottom = titlePaddingBottom
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
            imageEdgeInsets.left = self.bounds.width - imageView.bounds.width - imagePaddingRight
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
