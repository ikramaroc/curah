//
//  ViewExtention.swift
//  Heart Test
//
//  Created by netset on 7/2/18.
//  Copyright © 2018 netset. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
@IBInspectable var cornerRadius: CGFloat {
    set {
        layer.cornerRadius = newValue
        clipsToBounds = newValue > 0
    }
    get {
        return layer.cornerRadius
    }
}
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
}
