//
//  SignUpViewController.swift
//  QurahApp
//
//  Created by netset on 7/13/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore

class SignUpViewController: BaseClass {
    
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var textFldEmailAddress: UITextField!
    @IBOutlet weak var textFldPassword: UITextField!
    @IBOutlet weak var textFldConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarWithBackBtnAndTitle(title: "Sign Up")
        btnCheckBox.isSelected = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func btnFacebookAct(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(readPermissions: [.email,.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print("FACEBOOK LOGIN FAILED: \(error)")
                Progress.instance.displayAlert(userMessage:error.localizedDescription)
            case .cancelled:
                print("User cancelled login.")
            case .success (let accessToken):
                print("ACCESS TOKEN \(accessToken.token.authenticationToken)")
                Progress.instance.show()
                let fbRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture"])
                fbRequest.start{(urlResponse, requestResult) in
                    switch requestResult {
                    case .failed(let error):
                        Progress.instance.hide()
                        print("error in graph request:", error)
                        break
                    case .success(let graphResponse):
                        Progress.instance.hide()
                        if let responseDictionary: NSDictionary = graphResponse.dictionaryValue as NSDictionary? {
                            print(responseDictionary)
                            //                            if !self.btnCheckBox.isSelected {
                            //                                self.displayAlert(userMessage: Validation.call.acceptTermsPrivacy)
                            //                            } else {
                            self.signUpAPI(strEmail: graphResponse.dictionaryValue!["email"] as! String,
                                           strPassword: "",
                                           strSocialId:  graphResponse.dictionaryValue!["id"] as! String,
                                           strRegistrationType: Param.facebook.rawValue,
                                           strFirstName: graphResponse.dictionaryValue!["first_name"] as! String,
                                           strLastName: graphResponse.dictionaryValue!["last_name"] as! String,
                                           imgUrl: URL(string: "https://graph.facebook.com/\(graphResponse.dictionaryValue!["id"] ?? "")/picture?")!, token: self.getDeviceToken())
                            //                            }
                            
//                            self.signUpAPI(strEmail: "babsi.j@hotmail.com",
//                                           strPassword: "",
//                                           strSocialId:  "10215127799643356",
//                                           strRegistrationType: Param.facebook.rawValue,
//                                           strFirstName: graphResponse.dictionaryValue!["first_name"] as! String,
//                                           strLastName: graphResponse.dictionaryValue!["last_name"] as! String,
//                                           imgUrl: URL(string: "https://graph.facebook.com/\(graphResponse.dictionaryValue!["id"] ?? "")/picture?")!, token: self.getDeviceToken())
                            
                            
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.createProfile.rawValue {
            let obj = segue.destination as! CreateEditProfileVC
            obj.strScreenType = "create"
        }
    }
    
    @IBAction func btnGoogleAct(_ sender: Any) {
        // Google + Integration
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnCheckBoxAct(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected=false
        } else {
            sender.isSelected=true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:-  ALL METHODS 
extension SignUpViewController  {
    
}

//MARK:-  ALL ACTIONS 
extension SignUpViewController  {
    
    func validations()  {
        if textFldEmailAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.displayAlert(userMessage: Validation.call.enterEmail)
        } else if !checkEmailValidation(textFldEmailAddress.text!) {
            super.displayAlert(userMessage: Validation.call.validEmail)
        }  else if textFldPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.displayAlert(userMessage: Validation.call.enterPassword)
        }  else if (textFldPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! < 8 {
            self.displayAlert(userMessage: Validation.call.passwordLimit)
        } else if textFldConfirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.displayAlert(userMessage: Validation.call.enterConfirmPassword)
        }  else if textFldPassword.text != textFldConfirmPassword.text {
            self.displayAlert(userMessage: Validation.call.passwordNotMatch)
        } else if !btnCheckBox.isSelected {
            self.displayAlert(userMessage: Validation.call.acceptTermsPrivacy)
        } else {
            self.signUpAPI(strEmail: textFldEmailAddress.text!, strPassword: textFldPassword.text!, strSocialId: "", strRegistrationType: Param.others.rawValue, strFirstName: "",strLastName: "", imgUrl: URL(string:"other")!, token: getDeviceToken())
        }
    }
    
    //MARK:- Sign Up API *******
    
    func signUpAPI(strEmail:String, strPassword:String, strSocialId: String, strRegistrationType:String, strFirstName: String,
                   strLastName:String, imgUrl:URL,token:String) {
        self.view.endEditing(true)
        APIManager.sharedInstance.signUpAPI(email:strEmail, password:strPassword, registerType: strRegistrationType, socialId: strSocialId,token:token) { (response) in
            ModalShareInstance.shareInstance.modalUserData = response
            if response.userInfo?.firstname == nil || response.userInfo?.firstname?.count == 0 {
                //                let actionSheetController = UIAlertController (title: Constants.App.name, message: response.message, preferredStyle: UIAlertControllerStyle.alert)
                //                actionSheetController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                var data = ModalShareInstance.shareInstance.modalUserData.userInfo
                data?.firstname = strFirstName
                data?.lastname = strLastName
                data?.profileImageUrl = imgUrl
                
                if strRegistrationType == "F" || strRegistrationType == "G"{
                    isSocialLogin = true
                }else {
                    isSocialLogin = false
                }
                
                ModalShareInstance.shareInstance.modalUserData.userInfo = data
                self.performSegue(withIdentifier: segueId.createProfile.rawValue, sender: nil)
                //                }))
                //                self.present(actionSheetController, animated:true, completion:nil)
            }  else if response.status! == 200 {
                SaveUserResponse.sharedInstance.saveToSharedPrefs(user: response)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.makingRoot("enterApp")
            }else {
                Progress.instance.displayAlert(userMessage: response.message!)
            }
        }
    }
    
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        self.validations()
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        popToRootVc()
    }
    
    @IBAction func privacyPolicyAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        vc.url = "https://curahapp.com/pages/Privacy-Policy"
        vc.navTitle = "Privacy Policy"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func termsConditionAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        vc.url = "https://curahapp.com/pages/Terms-Conditions"
        vc.navTitle = "Terms and Conditions"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension SignUpViewController : GIDSignInDelegate,GIDSignInUIDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            Progress.instance.displayAlert(userMessage:error.localizedDescription)
            return
        }
        //        if !btnCheckBox.isSelected {
        //            self.displayAlert(userMessage: Validation.call.acceptTermsPrivacy)
        //        } else {
        self.signUpAPI(strEmail: user.profile.email, strPassword: "", strSocialId: user.userID, strRegistrationType: Param.google.rawValue, strFirstName: user.profile.givenName, strLastName: user.profile.familyName, imgUrl: user.profile.hasImage ? user.profile.imageURL(withDimension: 300) : URL(string:"other")!, token: getDeviceToken())
        //        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google Disconnected")
        Progress.instance.displayAlert(userMessage:error.localizedDescription)
    }
}


extension SignUpViewController: UITextFieldDelegate {
    
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
        if textField==textFldPassword || textField==textFldConfirmPassword {
            if string == " " {
                return false
            }
        }
        return true
    }
}


