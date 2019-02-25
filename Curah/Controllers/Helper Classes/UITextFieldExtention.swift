//
//  LabelExtention.swift
//  QurahApp
//
//  Created by netset on 7/13/18.
//  Copyright © 2018 netset. All rights reserved.
//

import Foundation
import UIKit
extension UITextField{
    @IBInspectable var placeholderLabeltextColor: UIColor? {
        get {
            return self.placeholderLabeltextColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[kCTForegroundColorAttributeName as NSAttributedStringKey: newValue!])
        }
    }
}

