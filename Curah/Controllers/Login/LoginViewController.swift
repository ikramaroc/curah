//
//  LoginViewController.swift
//  QurahApp
//
//  Created by netset on 7/13/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import Crashlytics

class LoginViewController: BaseClass {
    @IBOutlet weak var textFldEmailAddress: UITextField!
    @IBOutlet weak var textFldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
      
//        textFldEmailAddress.text = "gs@yopmail.com"
//        textFldPassword.text = "12345678"

        
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
         transparentNavigationBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        self.Validations()
    }
    
    func Validations() {
        self.view.endEditing(true)
        if textFldEmailAddress.text?.count==0 {
            Progress.instance.displayAlert(userMessage:Validation.call.enterEmail)
        } else if !checkEmailValidation(textFldEmailAddress.text!) {
            Progress.instance.displayAlert(userMessage:Validation.call.validEmail)
        } else if textFldPassword.text?.count==0 {
            Progress.instance.displayAlert(userMessage:Validation.call.enterPassword)
        } else {
            self.loginAPI()
        }
    }
    
    //MARK:- Login API *******
    
    func loginAPI() {
        APIManager.sharedInstance.loginAPI(email: textFldEmailAddress.text!, password: textFldPassword.text!,token:getDeviceToken()) { (response) in
            
            if response.status == 200 {
                isSocialLogin = false
            ModalShareInstance.shareInstance.modalUserData = response
            if response.userInfo?.firstname == nil || response.userInfo?.firstname?.count == 0 {
                self.performSegue(withIdentifier: segueId.loginToCreateProfile.rawValue, sender: nil)
//            } else if response.cardAdded! {
//                SaveUserResponse.sharedInstance.saveToSharedPrefs(user: response)
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.makingRoot("enterApp")
            } else {
                SaveUserResponse.sharedInstance.saveToSharedPrefs(user: response)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.makingRoot("enterApp")
                
                // self.performSegue(withIdentifier: "segueAddCardDetails", sender: "Add Card")
                }
                
            }else if response.status == 404{
                Progress.instance.displayAlert(userMessage: response.message!)
            }
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.loginToCreateProfile.rawValue {
            let obj = segue.destination as! CreateEditProfileVC
            obj.strScreenType = "create"
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji" || !((textField.textInputMode?.primaryLanguage) != nil)) {
            return false
        }
        if (textField.text?.count)! == 0 && string == " " {
            return false
        }
        if textField==textFldPassword {
            if string == " " {
                return false
            }
        }
        return true
    }
}
