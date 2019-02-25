
//
//  File.swift
//  WalFly
//
//  Created by Ranjana Prashar on 4/10/18.
//  Copyright © 2018 Netset. All rights reserved.
//
import UIKit
import Foundation
extension UIButton
{
    func setborderColor(color:UIColor)
{
    self.layer.borderColor = color.cgColor // borderColor

    }


//        @IBInspectable var borderColor: UIColor? {
//            set {
//                layer.borderColor = newValue?.cgColor
//            }
//            get {
//                guard let color = layer.borderColor else {
//                    return nil
//                }
//                return UIColor(cgColor: color)
//            }
//        }
//        @IBInspectable var borderWidth: CGFloat {
//            set {
//                layer.borderWidth = newValue
//            }
//            get {
//                return layer.borderWidth
//            }
//        }
//        @IBInspectable var cornerRadius: CGFloat {
//            set {
//                layer.cornerRadius = newValue
//                clipsToBounds = newValue > 0
//            }
//            get {
//                return layer.cornerRadius
//            }
//        }
    }


