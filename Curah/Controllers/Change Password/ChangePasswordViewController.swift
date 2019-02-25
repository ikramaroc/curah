//
//  ChangePasswordViewController.swift
//  Curah
//
//  Created by netset on 08/02/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseClass {
    @IBOutlet weak var currentPasswordTxt: UCTextFld!
    @IBOutlet weak var newPasswordTxt: UCTextFld!
    @IBOutlet weak var confirmPasswordTxt: UCTextFld!
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Change Password"
        super.setupBackBtn(tintClr: .white)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        checkValidations()
        
    }
    func checkValidations(){
        if currentPasswordTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.displayAlert(userMessage: Validation.call.enterOldPassword)
        }
        else if newPasswordTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.displayAlert(userMessage: Validation.call.enterNewPassword)
        }
        else  if confirmPasswordTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.displayAlert(userMessage: Validation.call.enterConfirmPassword)
        }  else if (newPasswordTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! < 8 {
            self.displayAlert(userMessage: Validation.call.passwordLimit)
        }  else if newPasswordTxt.text != confirmPasswordTxt.text {
            self.displayAlert(userMessage: Validation.call.passwordNotMatch)
        } else {
            changePassword()
        }
    }
    func changePassword(){
        APIManager.sharedInstance.changePasswordAPI(currentPassword: currentPasswordTxt.text!, newPassword: newPasswordTxt.text!) { (response) in
            Progress.instance.alertMessageOkWithBack(title: "", message: response.message!, viewcontroller: self)
      
            // self.textFldName.text = ""
            self.navigationController?.popViewController(animated: true)
            self.currentPasswordTxt.text = ""
            self.newPasswordTxt.text = ""
            self.confirmPasswordTxt.text = ""
            print(response)
        }
        
    }
}
