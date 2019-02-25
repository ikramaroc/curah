//
//  UCTextFld.swift
//  United Cabs
//
//  Created by Shopaves on 17/03/18.
//  Copyright © 2018 Shopaves. All rights reserved.
//

import UIKit

class UCTextFld: UITextField {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    @IBInspectable
    override  var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    override var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    override var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
    
    @IBInspectable var leftImage : UIImage? {
        didSet {
            if let image = leftImage {
                leftViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 20, y: 0, width: 20, height: 20))
                imageView.image = image
                imageView.tintColor = tintColor
                imageView.contentMode = .scaleAspectFit
                // let view = UIView(frame : CGRect(x: 0, y: 0, width: 25, height: 20))
                // view.addSubview(imageView)
                leftView = imageView
            } else {
                leftViewMode = .never
            }
        }
    }
    
    @IBInspectable var rightImage : UIImage? {
        didSet {
            if let image = rightImage {
                rightViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.image = image
                imageView.tintColor = tintColor
                imageView.contentMode = .scaleAspectFit
                let view = UIView(frame : CGRect(x: 0, y: 0, width: imageView.frame.size.width+10, height: imageView.frame.size.height))
                view.addSubview(imageView)
                rightView = view
            } else {
                rightViewMode = .never
            }
        }
    }
    
    
    @IBInspectable
    var spacerWidth: CGFloat = 0.0 {
        didSet {
            leftViewMode = .always
            let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: spacerWidth, height: self.frame.size.height))
            leftView = spacerView
        }
    }
    
    
    
    @IBInspectable var leftSpace : UIView? {
        didSet {
            if leftSpace != nil {
            } else {
                leftViewMode = .never
            }
        }
    }
    
    //    override func textRect(forBounds bounds: CGRect) -> CGRect {
    //        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    //    }
    //
    //    override func editingRect(forBounds bounds: CGRect) -> CGRect {
    //        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    //    }
    
    
    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 2.0
        self.clipsToBounds=true
    }
    
    /*  @IBInspectable var viewUnderlineColor : UIColor? {
     //DispatchQueue.global(qos: .userInteractive).async {
     //DispatchQueue.main.async {
     get {
     return self.viewUnderlineColor
     }
     set {
     self.borderStyle = UITextBorderStyle.none
     let border = CALayer()
     let width = 1
     border.borderColor = newValue?.cgColor
     border.frame = CGRect(x: 0, y: self.frame.size.height - CGFloat(width),   width:  self.frame.size.width, height: self.frame.size.height)
     border.borderWidth = CGFloat(width)
     self.layer.addSublayer(border)
     self.layer.masksToBounds = true
     }
     //  }
     //}
     }*/
    
    @IBInspectable var placeholderColor : UIColor? {
        get {
            return self.placeholderColor
        } set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}

extension UITextField {
    func setBottomBorder() {
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.borderStyle = UITextBorderStyle.none
                let border = CALayer()
                let width = 1
                border.borderColor = UIColor.black.withAlphaComponent(0.85).cgColor
                border.frame = CGRect(x: 0, y: self.frame.size.height - CGFloat(width),   width:  self.frame.size.width, height: self.frame.size.height)
                border.borderWidth = CGFloat(width)
                self.layer.addSublayer(border)
                self.layer.masksToBounds = true
            }
        }
    }
}
