//
//  SettingsVC.swift
//  QurahApp
//
//  Created by netset on 7/17/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import StoreKit

class SettingsVC: BaseClass {
    var settingsData = [String]()
let urlArray = ["","http://curahapp.com/","","https://curahapp.com/pages/Privacy-Policy","https://curahapp.com/pages/Terms-Conditions","",""]

    @IBOutlet weak var tableViewSettings: UITableView!
    
    override func viewDidLoad() {
        
        if isSocialLogin{
           settingsData = ["Notifications", "About Us", "Contact Us", "Privacy Policy", "Terms and Conditions", "Rate App", "Logout"]
        }else{
            settingsData = ["Notifications", "About Us", "Contact Us", "Privacy Policy", "Terms and Conditions", "Rate App","Change Password","Logout"]
        }
        
        super.viewDidLoad()
        self.title = "Settings"
        super.setupMenuBarButton()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openBrowser(type:Int){
        if let url = URL(string: urlArray[type]) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    //MARK:- Switching Of Notifications API *******
    
    func switchNotificationsAPI(switchValue:String, switch:UISwitch) {
        APIManager.sharedInstance.changeNotificationAPI(status: switchValue) { (response) in
            print(switchValue)
            ModalShareInstance.shareInstance.modalUserData.userInfo?.notificationType = switchValue
            SaveUserResponse.sharedInstance.saveToSharedPrefs(user: ModalShareInstance.shareInstance.modalUserData)
            self.tableViewSettings.reloadData()
        }
    }
}


extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = settingsData[indexPath.row]
        cell?.detailTextLabel?.text = (indexPath.row == 0) ? "Turn On/Off your Push Notification" : ""
        cell?.selectionStyle = .none
        return self.configureCell(cell: cell!, indexpath: indexPath)
    }
    
    func configureCell(cell:UITableViewCell, indexpath:IndexPath) -> UITableViewCell {
        let imageView  = UIImageView(frame:CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView.image = #imageLiteral(resourceName: "right_arrow")
        
        let objSwitch = UISwitch(frame: CGRect.zero) as UISwitch
        objSwitch.isOn = (ModalShareInstance.shareInstance.modalUserData.userInfo?.notificationType == Param.on.rawValue) ? true : false
        objSwitch.onTintColor = UIColor.init(hexString: "#CEDCA8")
        objSwitch.addTarget(self, action: #selector(switchTriggered), for: .valueChanged)
        
        cell.accessoryView = (indexpath.row == 0) ? objSwitch : imageView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 0) ? 80 : 60
    }
    
    @objc func switchTriggered(sender: UISwitch) {
        if sender.isOn {
            // on
            self.switchNotificationsAPI(switchValue: Param.on.rawValue, switch:sender)
        } else {
            // off
            self.switchNotificationsAPI(switchValue: Param.off.rawValue, switch:sender)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsData1 = ["Notifications", "About Us", "Contact Us", "Privacy Policy", "Terms and Conditions", "Rate App", "Logout"]
        
        if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            vc.url = urlArray[indexPath.row]
            vc.navTitle = settingsData1[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "segueContactUs", sender:nil)
        } else if indexPath.row == 3 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            vc.url = urlArray[indexPath.row]
            vc.navTitle = settingsData1[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            vc.url = urlArray[indexPath.row]
            vc.navTitle = settingsData1[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            if #available( iOS 10.3,*){
                SKStoreReviewController.requestReview()
            }
        } else if indexPath.row == 6 {
            
            if isSocialLogin{
                let actionSheetController = UIAlertController (title: "Are you sure you want to logout ?", message: "", preferredStyle: UIAlertControllerStyle.alert)
                //Add Cancel-Action
                actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                //Add Save-Action
                actionSheetController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                    UserDefaults.standard.removeObject(forKey: "USERDETAILS")
                    UserDefaults.standard.synchronize()
                    ModalShareInstance.shareInstance.modalUserData = nil
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.makingRoot("initial")
                }))
                //present actionSheetController
                present(actionSheetController, animated:true, completion:nil)
            }else {
                
                let viewObj = storyboard!.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                
  
                self.navigationController!.pushViewController(viewObj, animated: true)
            } 
            
        } else if indexPath.row == 7 && !isSocialLogin {
           
            let actionSheetController = UIAlertController (title: "Are you sure you want to logout ?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            //Add Cancel-Action
            actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            //Add Save-Action
            actionSheetController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                UserDefaults.standard.removeObject(forKey: "USERDETAILS")
                UserDefaults.standard.synchronize()
                ModalShareInstance.shareInstance.modalUserData = nil
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.makingRoot("initial")
            }))
            //present actionSheetController
            present(actionSheetController, animated:true, completion:nil)
        }
    }
}
