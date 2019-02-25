//
//  CancelAppointmentPopupVC.swift
//  QurahApp
//
//  Created by netset on 7/23/18.
//  Copyright © 2018 netset. All rights reserved.
//
@objc public protocol CallbackCancelAppointment {
    func reloadAppointmentDetailData(reason:String)
}

import UIKit

class CancelAppointmentPopupVC: UIViewController {
    var selectedIndex : Int = 0
    var bookingId : Int = 0
    var reason : String = ""
    var objProtocol : CallbackCancelAppointment?
    @IBOutlet weak var viewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var tblVwCancelAppointment: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    @IBAction func btnCancelAct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitAct(_ sender: Any) {
        if selectedIndex == 0  {
            reason = Param.reasonForCancel.rawValue
        } else {
            self.checkforOtherResaons()
        }
        if reason.count != 0 {
            APIManager.sharedInstance.cancelAppointmentAPI(id: bookingId, reason: reason) { (response) in
                self.objProtocol?.reloadAppointmentDetailData(reason: self.reason)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension CancelAppointmentPopupVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 1 {
            return 3
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell : CellReason = tableView.dequeueReusableCell(withIdentifier: "CellReason") as! CellReason
            cell.textVwReason.text = ""
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return self.configureCell(cell: cell!, indexpath: indexPath)
    }
    
    func configureCell(cell:UITableViewCell, indexpath:IndexPath) -> UITableViewCell {
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: Constants.AppFont.fontAvenirBook, size: 15.0)
        switch indexpath.row {
        case 0:
            cell.textLabel?.text = Param.reasonForCancel.rawValue
            break
        case 1:
            cell.textLabel?.text = "Other reason."
            break
        default:
            break
        }
        if selectedIndex == indexpath.row {
            cell.imageView?.image = #imageLiteral(resourceName: "gree_fill")
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "green")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex != indexPath.row {
            selectedIndex = indexPath.row
            if indexPath.row == 1 {
                print("Show third cell")
                self.viewHeightConst.constant = 420
            } else {
                self.viewHeightConst.constant = 320
            }
            tableView.reloadData()
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 100
        }
        return 45
    }
}

extension CancelAppointmentPopupVC : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        reason = textView.text
    }
    
    func checkforOtherResaons() {
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = tblVwCancelAppointment.cellForRow(at: indexPath) as! CellReason
        if cell.textVwReason.text.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            Progress.instance.displayAlert(userMessage: "Please enter reason for cancel appointment")
        } else {
            reason = cell.textVwReason.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

class CellReason: UITableViewCell {
    @IBOutlet weak var textVwReason: UITextView!
}

