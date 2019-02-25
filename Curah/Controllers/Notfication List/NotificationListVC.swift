//
//  NotificationListVC.swift
//  QurahApp
//
//  Created by netset on 7/18/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class NotificationListVC: BaseClass {
    @IBOutlet weak var tblVwNotifications: UITableView!
    var noHistoryDataLbl = UILabel()

    var notificationList : ModalBase!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setupMenuBarButton()
        self.title = "Notifications"
        tblVwNotifications.rowHeight = UITableViewAutomaticDimension
        tblVwNotifications.estimatedRowHeight = 100
        let originY = navigationController?.navigationBar.frame.maxY
        noHistoryDataLbl = UILabel(frame: CGRect(x: 0, y: originY! , width: self.view.frame.size.width, height: self.view.frame.size.height-originY!))
        
        noHistoryDataLbl.backgroundColor = UIColor.white
        noHistoryDataLbl.textColor = UIColor.black
        noHistoryDataLbl.font = UIFont(name: Constants.AppFont.fontAvenirRoman, size: 18)
        noHistoryDataLbl.text = ""
        noHistoryDataLbl.isHidden = false
        noHistoryDataLbl.textAlignment = .center
        self.view.addSubview(noHistoryDataLbl)
        
        self.tblVwNotifications.isHidden = true
        getNotificationListAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK:- Get Notification API
    func getNotificationListAPI() {
        APIManager.sharedInstance.getNotificationList() { (response) in
            print(response)
            self.notificationList = response
            if (self.notificationList.notifications?.count)! > 0{
                self.tblVwNotifications.isHidden = false
            let sortedByDate = self.notificationList?.notifications?.sorted { (Notification1, Notification2) -> Bool in
                return  super.convertToLocalDateFormatDate(utcDate:Notification1.date!).compare(super.convertToLocalDateFormatDate(utcDate: Notification2.date!)) == .orderedDescending
            }
                self.noHistoryDataLbl.isHidden = true

                self.notificationList.notifications = sortedByDate
                self.tblVwNotifications.reloadData()
                
            }else{
                self.noHistoryDataLbl.text = "No notifications found"
                self.tblVwNotifications.isHidden = true
            }
        }
    }

}


extension NotificationListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          guard self.notificationList != nil else {
            return 0
        }
        return (self.notificationList.notifications?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let data = self.notificationList.notifications?[indexPath.row]
        cell?.textLabel?.setHTML(html: (data?.message)!)
        cell?.textLabel?.font = UIFont(name: Constants.AppFont.fontAvenirMedium, size: 11.0)
        cell?.detailTextLabel?.font = UIFont(name: Constants.AppFont.fontAvenirMedium, size: 11.0)
        cell?.detailTextLabel?.text = convertToLocalDateFormatOnlyTime(utcDate: (data?.date)!)
        cell?.selectionStyle = .none
        return self.configureCell(cell: cell!, indexpath: indexPath)
    }
    
    func configureCell(cell:UITableViewCell, indexpath:IndexPath) -> UITableViewCell {
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.notificationList.notifications![indexPath.row].type! != "M"{
            getAppoitmentDetailAPI(id: (self.notificationList.notifications![indexPath.row].notification_id!))
        }else{
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            newViewController.connection_id = Int((self.notificationList.notifications?[indexPath.row].notification_id)!)!
            newViewController.receiver_id = self.notificationList.notifications?[indexPath.row].receiver_id!
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    // MARK:- Get AppoitmentDetail API
    func getAppoitmentDetailAPI(id:String) {
        APIManager.sharedInstance.appointmentDetailAPI(bookingId: Int(id)!) { (response) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceDetailsVC") as! ServiceDetailsVC
            vc.detail = response
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

extension UILabel {
    func changeTextColor(fullText:NSString , strUserName:String, strServiceName:String ) {
        let rangeOfUserName = (fullText).range(of: strUserName)
        let rangeOfServiceName = (fullText).range(of: strServiceName)
        let attribute = NSMutableAttributedString.init(string: fullText as String)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: Constants.appColor.appColorMainGreen , range: rangeOfUserName)
        attribute.addAttribute(NSAttributedStringKey.font, value: UIFont(name: Constants.AppFont.fontHeavy, size: 17.0)!, range: rangeOfUserName)
        
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: Constants.appColor.appColorMainGreen , range: rangeOfServiceName)
        attribute.addAttribute(NSAttributedStringKey.font, value: UIFont(name: Constants.AppFont.fontHeavy, size: 17.0)!, range: rangeOfServiceName)
        self.attributedText = attribute
    }
}

