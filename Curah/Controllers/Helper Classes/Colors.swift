//
//  Colors.swift
//  WalFly
//
//  Created by Ranjana Prashar on 4/16/18.
//  Copyright © 2018 Netset. All rights reserved.
//
import UIKit
import Foundation
extension UIColor {
        
        convenience init(rgb: UInt) {
            self.init(rgb: rgb, alpha: 1.0)
        }
        
        convenience init(rgb: UInt, alpha: CGFloat) {
            self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgb & 0x0000FF) / 255.0,
                alpha: CGFloat(alpha)
            )
        }
    }

