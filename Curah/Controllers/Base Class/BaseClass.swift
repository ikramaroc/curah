//
//  BaseClass.swift
//  WalFly
//
//  Created by Ranjana Prashar on 4/16/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import LGSideMenuController
import GoogleMaps
import CoreLocation

class BaseClass: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func locationServicesEnabled() -> Bool {
        var isEnable : Bool = false
        let status = CLLocationManager.authorizationStatus()
        if status == .denied { //status == .notDetermined ||
            let alert = UIAlertController(title: "Location Services Disabled", message: "Your currently all location services for this device disabled. Please go to settings to give access." , preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style:.default, handler:{ (action: UIAlertAction!) in
                let url:URL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!)!
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: {
                        (success) in })
                } else {
                    guard UIApplication.shared.openURL(url) else {
                        return
                    }
                }}))
            self.present(alert, animated: true, completion: nil)
        } else {
            isEnable = true
        }
        return isEnable
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- pop view contrller here
    @objc func PopViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- push vc here
    func pushToViewController(VC:String) {
        let targetVc = self.storyboard?.instantiateViewController(withIdentifier:VC)
        self.navigationController?.pushViewController(targetVc!, animated: true)
    }
    
    
    func underLineTextFldBottomLine(mainView:UIView) {
        for subVw in mainView.subviews {
            if subVw.isKind(of: UITextField.self) {
                let textFld = subVw as! UITextField
                textFld.setBottomBorder()
            }
        }
    }
    
    func alertMessageWithActionOk(title: String, message: String, viewcontroller:UIViewController,action:@escaping ()->())
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "OK", style: .default) {  (result : UIAlertAction) -> Void in
            print("You pressed Upload")
            
            action()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:- push vc here
    func popToRootVc() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK:- Dismiss Keyboard
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    //MARK:- Show Alert
//    func showAlert(message:String) {
//        let alert = UIAlertController(title: Constants.AppName.app_Name, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//        }))
//        present(alert, animated: true, completion: nil)
//    }
//    func showAlertWithAction(message:String,onComplete:@escaping (()->())) {
//        let alert = UIAlertController(title: Constants.AppName.app_Name, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//            onComplete()
//        }))
//        present(alert, animated: true, completion: nil)
//    }
    
    
    // MARK: - Change Date and Time
    func changeDateFormat(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.string(from: selectedDate!)
    }
    
    
    // MARK: - Change Birth Date
    func changeBirthDateFormat(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        return dateFormatter.string(from: selectedDate!)
    }
    
    
    func getFormattedString(selectedDate:Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.string(from: selectedDate)
    }
    
    func changeTimeFormat(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date!)
    }
    
    
    func convertToLocalDateFormatOnlyTimeToDate(utcDate:String) -> Date {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dt = dateFormatter.date(from: utcDate)
        return dt!
    }
    
    func convertToLocalDateFormatDate(utcDate:String) -> Date {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dt = dateFormatter.date(from: utcDate)
        return dt!
    }
    
   func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
   /* func showNavigationBarWithOnlyBack() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(#imageLiteral(resourceName: "back"), for: UIControlState())
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        btnLeftMenu.addTarget(self, action: #selector(BaseClass.PopViewController), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnLeftMenu.imageEdgeInsets = UIEdgeInsets(top: 0, left: -17, bottom: 0, right: 0)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.title = ""
    }*/
    
    
    func transparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
   
    func setNavigationBarWithBackBtnAndTitle(title:String) {
        self.navigationItem.title = title
        //  self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(#imageLiteral(resourceName: "back"), for: UIControlState())
        /*self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear*/
        btnLeftMenu.addTarget(self, action: #selector(BaseClass.PopViewController), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnLeftMenu.imageEdgeInsets = UIEdgeInsets(top: 0, left: -17, bottom: 0, right: 0)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func addSideMenuWithTitle() {
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "menu_button3"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn1.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        //        btn1.backgroundColor = UIColor.black
        btn1.addTarget(self, action: #selector(menuBtnAction), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)
    }
    
    @IBAction func menuBtnAction() {
        sideMenuController?.showLeftViewAnimated()
    }
    
    //MARK: convert Array into JSON String
    func convertArrayToJSONString(value: AnyObject) -> String? {
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch{
            }
        }
        return nil
    }
    
    func setUpButtonShadow(btn:UIButton) {
        DispatchQueue.main.async {
            btn.layer.shadowColor = UIColor.init(hexString: "#C696AE").cgColor
            btn.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            btn.layer.shadowOpacity = 0.4
            btn.layer.shadowRadius = 4.0
            btn.layer.cornerRadius = 19
            btn.layer.masksToBounds = false
        }
    }
    
    func setUpButtonShadow(btn:UIButton, _ color:UIColor, _ cornerRadius:CGFloat) {
        DispatchQueue.main.async {
            btn.layer.shadowColor = color.cgColor
            btn.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
            btn.layer.shadowOpacity = 0.2
            btn.layer.shadowRadius = 10.0
            btn.layer.cornerRadius = cornerRadius
            btn.layer.masksToBounds = false
        }
    }
    
    func setUpLabelShadow(lbl:UILabel, _ color:UIColor, _ cornerRadius:CGFloat) {
        DispatchQueue.main.async {
            lbl.layer.shadowColor = color.cgColor
            lbl.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
            lbl.layer.shadowOpacity = 0.4
            lbl.layer.shadowRadius = 4.0
            lbl.layer.cornerRadius = cornerRadius
            lbl.layer.masksToBounds = false
        }
    }
    
    func setUpViewShadow(vw:UIView) {
        DispatchQueue.main.async {
            vw.layer.shadowColor = UIColor.black.cgColor
            vw.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            vw.layer.shadowOpacity = 0.4
            vw.layer.shadowRadius = 2.0
           // vw.layer.cornerRadius = CGFloat(cornerRadius)
            vw.layer.masksToBounds = false
        }
    }
    
    // ****************************
    func setupMenuBarButton() {
        DispatchQueue.main.async {
            let btnOnMenuLeftSide = UIBarButtonItem(image:#imageLiteral(resourceName: "menu_icon"), style: .plain, target: self, action: #selector(BaseClass.showLGSideMenu(_:)))
            btnOnMenuLeftSide.tintColor = .white
            self.navigationItem.leftBarButtonItem = btnOnMenuLeftSide
        }
    }
    
    @objc func showLGSideMenu(_ sender: UIBarButtonItem) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    func setupBackButton() {
        let btnOnMenuLeftSide = UIBarButtonItem(image:#imageLiteral(resourceName: "back_icon"), style: .plain, target: self, action: #selector(BaseClass.btnBack(_:)))
        btnOnMenuLeftSide.tintColor = .black
        self.navigationItem.leftBarButtonItem = btnOnMenuLeftSide
    }
    
    func setupBackBtn(tintClr:UIColor) {
        let btnOnMenuLeftSide = UIBarButtonItem(image:#imageLiteral(resourceName: "back_icon"), style: .plain, target: self, action: #selector(BaseClass.btnBack(_:)))
        btnOnMenuLeftSide.tintColor = tintClr
        self.navigationItem.leftBarButtonItem = btnOnMenuLeftSide
    }
    
    @objc func btnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setSearcBar(bar:UISearchBar,font:UIFont) {
        bar.setImage(#imageLiteral(resourceName: "search"), for: .search, state: .normal)
        if let textfield = bar.value(forKey: "searchField") as? UITextField {
            textfield.font = font
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 2;
                backgroundview.clipsToBounds = true;
            }
        }
    }
    
    // MARK: - Email Validation
    func checkEmailValidation(_ string: String) -> Bool {
        let stricterFilterString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", stricterFilterString)
        return emailTest.evaluate(with: string)
    }
    
    func displayAlert( userMessage: String,  completion: (() -> ())? = nil) {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        let alertView = UIAlertController(title: Constants.App.name, message: userMessage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            if completion != nil {
                completion!()
            }
        }))
        topVC?.present(alertView, animated: true, completion: nil)
    }
}
