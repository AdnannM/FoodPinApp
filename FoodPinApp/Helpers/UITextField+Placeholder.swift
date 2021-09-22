//
//  UITextField+Placeholder.swift
//  FoodPinApp
//
//  Created by Adnann Muratovic on 22.09.21.
//

import Foundation
import UIKit

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            if let placeholder = self.placeholder {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : newValue!])
            }
        }
    }
}
