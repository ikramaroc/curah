//
//  ContactUsVC.swift
//  QurahApp
//
//  Created by netset on 7/17/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class ContactUsVC: BaseClass {

    @IBOutlet weak var textVwMessage: UITextView!
    @IBOutlet weak var textViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var textFldName: UITextField!
    @IBOutlet weak var textFldSubject: UITextField!
    @IBOutlet weak var textFldEmailAddress: UITextField!
   
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact Us"
        super.setupBackBtn(tintClr: .white)
        super.underLineTextFldBottomLine(mainView: contentView)
        textFldName.text = (ModalShareInstance.shareInstance.modalUserData.userInfo?.firstname)! + " " + (ModalShareInstance.shareInstance.modalUserData.userInfo?.lastname)!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnSubmitAct(_ sender: Any) {
         self.validations()
    }
    
    func validations() {
        if textFldName.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterYourName)
        } else if textFldSubject.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterSubject)
        } else if textFldEmailAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.enterEmail)
        } else if !checkEmailValidation(textFldEmailAddress.text!) {
            Progress.instance.displayAlert(userMessage: Validation.call.validEmail)
        }  else if textVwMessage.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.entermessage)
        } else {
            APIManager.sharedInstance.contactUsAPI(name: (textFldName.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                                                   subject: (textFldSubject.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                                                   email: (textFldEmailAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                                                   message: (textVwMessage.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) { (response) in
                                                    Progress.instance.displayAlert(userMessage: response.message!)
                                                    // self.textFldName.text = ""
                                                    self.textFldEmailAddress.text = ""
                                                    self.textFldSubject.text = ""
                                                    self.textVwMessage.text = ""
                                                    print(response)
            }
        }
    }
    
}


extension ContactUsVC : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textViewNotasChange(textVw:textView)
    }
    
    func textViewNotasChange(textVw:UITextView) {
        textVw.translatesAutoresizingMaskIntoConstraints = true
        textVw.sizeToFit()
        textVw.isScrollEnabled = false
        let calHeight = textVw.frame.size.height
        textVw.frame = CGRect(x: textFldName.frame.origin.x, y: textVw.frame.origin.y, width: textFldName.frame.size.width, height: calHeight)
        if calHeight > 80 {
            textViewHeightConst.constant = calHeight
        } else {
            textViewHeightConst.constant = 80
        }
        textVw.translatesAutoresizingMaskIntoConstraints=false
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}


extension ContactUsVC: UITextFieldDelegate {
    
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
        return true
    }
}

