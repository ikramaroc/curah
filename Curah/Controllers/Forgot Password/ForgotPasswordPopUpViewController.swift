//
//  ForgotPasswordPopUpViewController.swift
//  QurahApp
//
//  Created by netset on 7/13/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class ForgotPasswordPopUpViewController: UIViewController {
    
    @IBOutlet weak var title_: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitialization()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
//MARK:-  ALL METHODS 
extension ForgotPasswordPopUpViewController {
    fileprivate func doInitialization() {
        let textToSet = """
        An email has been sent to your
        registered email address. Follow
        the directions in the email to
        reset your password.
        """
        let attributedString = NSMutableAttributedString(string:textToSet)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        title_.attributedText = attributedString
    }
    
}
//MARK:-  ALL ACTIONS 
extension ForgotPasswordPopUpViewController {
    @IBAction func doneAction(_ sender: Any) {
        let presentingVC = self.presentingViewController!
        let navigationController = presentingVC is UINavigationController ? presentingVC as? UINavigationController : presentingVC.navigationController
        navigationController?.popToRootViewController(animated: false)
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

