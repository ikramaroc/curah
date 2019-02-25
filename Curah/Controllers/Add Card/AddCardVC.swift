//
//  AddCardVC.swift
//  QurahApp
//
//  Created by netset on 7/23/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

@objc public protocol CallbackOnCardListingScreen {
    @objc optional func callCardListingAPI()
}

class AddCardVC: BaseClass {
    var objProtocol : CallbackOnCardListingScreen?
    @IBOutlet weak var textFldEnterCard: UCTextFld!
    @IBOutlet weak var textFldCardName: UCTextFld!
    @IBOutlet weak var textFldExpiryDate: UCTextFld!
    @IBOutlet weak var textFldCVV: UCTextFld!
    var boolCardStatus : Bool = false
    let picker = MonthYearPickerView()
    var screenType:String=""
    var cardDetail : Cards?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if cardDetail != nil {
            self.title = "Edit Card"
            self.setCardDetail()
        } else {
            self.title = "Add Card"
        }
        self.underLineTextFldBottomLine(mainView: self.view)
        textFldExpiryDate.inputView = picker
        picker.onDateSelected = { (month: Int, year: Int) in
             let yearValue : String = String(year)
             let last2 = String(yearValue.suffix(2))
             self.textFldExpiryDate.text =  String(format: "%02d", month) + "/" + last2
        }
        self.setDetails()
    }
    
    func setDetails() {
        if screenType.count == 0 {
             self.rightBarButton()
            self.navigationItem.hidesBackButton=true
        } else {
            super.setupBackBtn(tintClr: .white)
        }
    }
    
    func setCardDetail() {
        textFldCardName.text = cardDetail?.nameOnCard
        textFldCVV.text = cardDetail?.cvv
        textFldEnterCard.placeholder = "**** **** **** " + (cardDetail?.last4)!
        textFldExpiryDate.text = (cardDetail?.expMonth)! + "/" + (cardDetail?.expYear)!
    }
    
    func rightBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipAct))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name:Constants.AppFont.fontAvenirRoman, size:15)!], for: .normal)
    }
    
    @objc func skipAct() {
        self.enterApp()
    }
    
    @IBAction func btnSubmitAct(_ sender: Any) {
        self.validations()
    }
    
    func validations() {
        self.view.endEditing(true)
        if textFldEnterCard.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 && cardDetail != nil {
            Progress.instance.displayAlert(userMessage:Validation.call.cardNumber)
        } else if !boolCardStatus {
            Progress.instance.displayAlert(userMessage:Validation.call.validCardNumber)
        } else if textFldCardName.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            Progress.instance.displayAlert(userMessage:Validation.call.name)
        }  else if textFldExpiryDate.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            Progress.instance.displayAlert(userMessage:Validation.call.expiryDate)
        } else if textFldCVV.text?.count == 0 {
            Progress.instance.displayAlert(userMessage:Validation.call.cvv)
        } else {
            if cardDetail != nil {
                APIManager.sharedInstance.editCardAPI(cardNo: Int(textFldEnterCard.text!)!, name: textFldCardName.text!, expirationDate: self.textFldExpiryDate.text!, cvv: Int(textFldCVV.text!)!, cardId: (cardDetail?.cardId)!) { (response) in
                      self.navigationController?.popViewController(animated: true)
                }
            } else {
                APIManager.sharedInstance.addCardAPI(cardNo: Int(textFldEnterCard.text!)!, name: textFldCardName.text!, expirationDate: self.textFldExpiryDate.text!, cvv: Int(textFldCVV.text!)!) { (response) in
                    if self.screenType.count == 0 {
                        self.enterApp()
                    } else {
                        self.navigationController?.popViewController(animated: true)
                        self.objProtocol?.callCardListingAPI!()
                    }
                }
            }
        }
    }
    
    func enterApp()  {
        let objAppDelegate = UIApplication.shared.delegate as! AppDelegate
        objAppDelegate.makingRoot("enterApp")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- UITextField delegate methods
extension AddCardVC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji" || !((textField.textInputMode?.primaryLanguage) != nil)) {
            return false;
        }
        if textField.text?.count  == 0 && string == " " {
            return false
        }
        if textField.isEqual(textFldCardName) {
            if (textField.text?.count)! >= 30 && range.length == 0 {
                return false
            }
            var characterSet = CharacterSet.letters
            characterSet.insert(charactersIn: " ")
            if (string as NSString).rangeOfCharacter(from: characterSet.inverted).location == NSNotFound {
                return true
            }
            return false
        } else if textField.isEqual(textFldEnterCard) {
            if (textField.text?.count)! >= 16 && range.length == 0 {
                return false
            }
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let text = (textField.text ?? "") as NSString
            
            let updatedString = text.replacingCharacters(in: range, with: string)
            boolCardStatus = updatedString.isValidCardNumber()
            return allowedCharacters.isSuperset(of: characterSet)
        } else if textField.isEqual(textFldCVV) {
            if (textField.text?.count)! >= 4 && range.length == 0 {
                return false
            }
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
