//
//  ServiceDetailsVC.swift
//  QurahApp
//
//  Created by netset on 7/18/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import FloatRatingView

class ServiceDetailsVC: BaseClass {
    var detail : ModalBase!
    @IBOutlet weak var viewForCancelService: UIView!
    @IBOutlet weak var viewReasonBottomConst: NSLayoutConstraint!
    @IBOutlet weak var lblStatusHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnCancelHeightConst: NSLayoutConstraint!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var viewAtFooter: UIView!
    @IBOutlet weak var tblVwDetails: UITableView!
    @IBOutlet weak var reasonMentioned: UILabel!
    @IBOutlet weak var lblReasonCancellation: UILabel!
    @IBOutlet weak var CancelBtnAppointment: UIButton!
    var fromPushNotification = false
    var bookingId = Int()
    //var strStatus:String!
    let identifiers = ["cellServicesNamePrice", "cellServiceDetails" , "cellServiceDescription", "cellBarberDetails","cellFeedback"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        super.setupBackBtn(tintClr: .white)
        currentScreenStr = "ServiceDetailsVC"
        //        if strStatus == nil {
        //            strStatus = "1"
        //        }
        tblVwDetails.tableFooterView = UIView()
        tblVwDetails.estimatedRowHeight = 50
        if !fromPushNotification{
            self.setData()
        }
       
        //service notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: NSNotification.Name(rawValue: "RefreshNotification"), object: nil)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
         bookingIdForNotification = (detail.appointmentDetails?.bookingId!)!
        if fromPushNotification{
            getAppoitmentDetailAPI()
        }
        fromPushNotification = false
        if isFromPaymentScreen{
            getAppoitmentDetailAPI()
        }
        isFromPaymentScreen = false
        
        
//        else{
//           detail.appointmentDetails?.bookingId = bookingId
//        }
    }
    
 
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
         currentScreenStr = ""
    }
    
    //MARK:- Notification Method
    @objc func methodOfReceivedNotification(notification: Notification) {
        getAppoitmentDetailAPI()
    }
    
    
    func setData() {
        
        
       /* if detail.appointmentDetails?.status == BookingStatus.cancelled.rawValue {
           // btnCancelHeightConst.constant = 0
            lblReasonCancellation.text = detail.appointmentDetails?.cancelDescription
            if detail.appointmentDetails?.cancelBy == Param.customer.rawValue {
                labelStatus.text = "Your have cancelled the appointment."
                reasonMentioned.text = "Reason you mentioned."
            } else {
                labelStatus.text = "Your appointment was cancelled by provider."
                reasonMentioned.text = "Reason mentioned."
            }
        } */
        
        
         if detail.appointmentDetails?.status == BookingStatus.waiting.rawValue {
            //self.setView(title: "Your appointment is waiting for response.", color: UIColor.black, btnReasonHeight: -200, btnCancelHeight: 50)
            labelStatus.text = "Your appointment is waiting for response."
            viewReasonBottomConst.constant = -42
        } else if detail.appointmentDetails?.status == BookingStatus.accept.rawValue {
            labelStatus.text = "Your appointment has been accepted."
            viewReasonBottomConst.constant = -42
            //  self.setView(title: "Your appointment has been accepted", color: UIColor.black, btnReasonHeight: -200, btnCancelHeight: 50)
        } else if detail.appointmentDetails?.status == BookingStatus.inProgress.rawValue {
            labelStatus.text = "Your service is in progress."
            labelStatus.textColor = Constants.appColor.appColorMainGreen
            viewReasonBottomConst.constant = -90
            // self.setView(title: "Your service is in progress", color: Constants.appColor.appColorMainGreen, btnReasonHeight: -200, btnCancelHeight: 0)
        }
         else if detail.appointmentDetails?.status == BookingStatus.reject.rawValue {
            labelStatus.text = "Your service has been rejected by Service Provider."
            
            labelStatus.textColor = UIColor.black
            viewReasonBottomConst.constant = -90
            // self.setView(title: "Your service is in progress", color: Constants.appColor.appColorMainGreen, btnReasonHeight: -200, btnCancelHeight: 0)
         }
         
         
         else if detail.appointmentDetails?.status == BookingStatus.completed.rawValue {
            self.setView(title: "", color: Constants.appColor.appColorMainGreen, btnReasonHeight: -200, btnCancelHeight: 0)
            lblStatusHeightConst.constant = 0
            
            if detail?.appointmentDetails?.payment_status == "Y" && detail?.rating?.providerMessage?.count == 0 {
                let newVc = self.storyboard?.instantiateViewController(withIdentifier: "RateReviewPopUpVC") as! RateReviewPopUpVC
                newVc.bookingId = (detail.appointmentDetails?.bookingId)!
                newVc.otherUserId = (detail.appointmentDetails?.providerId)!
                newVc.providesPresentationContextTransitionStyle = true
                newVc.definesPresentationContext = true
                newVc.delegate = self
                newVc.modalPresentationStyle = .overCurrentContext
                self.present(newVc, animated: true, completion: nil)
            }else if detail?.appointmentDetails?.payment_status != "Y" {
                
                super.alertMessageWithActionOk(title: "Curah Customer", message: "You have pending payments click on to pay", viewcontroller: self) {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"SelectPaymentMethodVC") as!  SelectPaymentMethodVC
                    
                    vc.bookingId = (self.detail.appointmentDetails?.bookingId!)!
                    vc.providerId = (self.detail.appointmentDetails?.providerId!)!
                    
                    var nameArr = [String]()
                    for service in (self.detail.appointmentDetails?.serviceNameArr!)!{
                        nameArr.append(service.name!)
                    }
                    vc.jobName = nameArr.joined(separator: ",")
                    vc.amount = (self.detail.appointmentDetails?.price!)!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            else if detail.appointmentDetails?.status == "C" && detail.appointmentDetails?.payment_status == "Y"{
                print("********* view receiptm ***********")
//                CancelBtnAppointment.isHidden = false
                btnCancelHeightConst.constant = 50
                CancelBtnAppointment.setTitle("VIEW RECEIPT ", for: .normal)
                viewReasonBottomConst.constant = 0
                
                
            }
        }
         
         
         else if detail.appointmentDetails?.status == BookingStatus.cancelled.rawValue {
            btnCancelHeightConst.constant = 0
            viewReasonBottomConst.constant = 0
            lblReasonCancellation.text = detail.appointmentDetails?.cancelDescription
            if detail.appointmentDetails?.cancelBy == Param.customer.rawValue {
                labelStatus.text = "You have cancelled the appointment."
                reasonMentioned.text = "Reason mentioned."
            } else {
                labelStatus.text = "Your appointment was cancelled by provider."
                reasonMentioned.text = "Reason mentioned."
            }
        } 
    }
    
    
    
    // MARK:- Get AppoitmentDetail API
    func getAppoitmentDetailAPI() {
        if bookingId == 0{
            bookingId = (detail.appointmentDetails?.bookingId!)!
        }
        APIManager.sharedInstance.appointmentDetailAPI(bookingId: bookingId) { (response) in
            self.detail = response
            self.setData()
            self.tblVwDetails.reloadData()
        }
    }
    
    func setView(title:String, color:UIColor, btnReasonHeight:Int, btnCancelHeight:CGFloat) {
        labelStatus.text = title
        labelStatus.textColor = color
        viewReasonBottomConst.constant = CGFloat(btnReasonHeight)
        btnCancelHeightConst.constant = btnCancelHeight
    }
    
    @IBAction func btnCancelAppointAct(_ sender: Any) {
        
        
        if detail.appointmentDetails?.status == "C" && detail.appointmentDetails?.payment_status == "Y"{
        
            print("Show receipt view")
             let receiptVc = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
           //  receiptVc.providesPresentationContextTransitionStyle = true
           //  receiptVc.definesPresentationContext = true
           // receiptVc.modalPresentationStyle = .overCurrentContext
           // self.present(receiptVc, animated: true, completion: nil)
            receiptVc.feedbackDataDict = detail.appointmentDetails!
            self.navigationController?.pushViewController(receiptVc, animated: true)
            
        }else{
            let newVc = self.storyboard?.instantiateViewController(withIdentifier: "CancelAppointmentPopupVC") as! CancelAppointmentPopupVC
            newVc.objProtocol = self
            newVc.bookingId = (detail.appointmentDetails?.bookingId)!
            
            newVc.providesPresentationContextTransitionStyle = true
            newVc.definesPresentationContext = true
            newVc.modalPresentationStyle = .overCurrentContext
            self.present(newVc, animated: true, completion: nil)
        }
        
//        self.performSegue(withIdentifier: segueId.cancelAppointment.rawValue, sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.cancelAppointment.rawValue {
            let objVC : CancelAppointmentPopupVC = segue.destination as! CancelAppointmentPopupVC
            objVC.objProtocol = self
            objVC.bookingId = (detail.appointmentDetails?.bookingId)!
            // objVC.detail = sender as! ModalBase
        }
    }
    
    
    //    vc.objProtocol = self
}

extension ServiceDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard self.detail != nil else {
                return 0
            }
            return detail.appointmentDetails?.serviceNameArr?.count == 0 ? 0 : (detail.appointmentDetails?.serviceNameArr?.count)!
        case 1:
            return 3
        case 2:
            return 0
        case 3:
            return 1
        case 4:
            return 2
        default:
            break
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return identifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.section])
        if indexPath.section == 0 {
            cell?.selectionStyle = .none
            let cell : CellServicesNamePrice = tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.section]) as! CellServicesNamePrice
            return self.configureCellServices(cell: cell, indexpath: indexPath)
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "SERVICE COST"
                cell?.detailTextLabel?.text = "$\(detail.appointmentDetails!.price!)"
                break
            case 1:
                cell?.textLabel?.text = "DATE"
                cell?.detailTextLabel?.text = super.changeDateFormat(strDate: (detail.appointmentDetails?.date!)!)
                break
            case 2:
                cell?.textLabel?.text = "TIME"
                cell?.detailTextLabel?.text =  super.changeTimeFormat(strDate: (detail.appointmentDetails?.startTime!)!) + " to " + super.changeTimeFormat(strDate: (detail.appointmentDetails?.closeTime!)!)//"11:00 am to 12:00 pm"
                break
            default:
                break
            }
        } else if indexPath.section == 2 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.section])
            let lblServiceName = cell1?.viewWithTag(44) as! UILabel
            lblServiceName.text = (detail.appointmentDetails?.description) ?? ""
            return cell1!
        } else if indexPath.section == 3 {
            let cell : CellBarberDetailsList = tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.section]) as! CellBarberDetailsList
            return self.configureCellBarberDetailsList(cell: cell, indexpath: indexPath)
        } else if indexPath.section == 4 {
            let cell : CellFeedbackDetails = tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.section]) as! CellFeedbackDetails
            return self.configureFeedbackCell(cell: cell, indexpath: indexPath)
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func configureCellServices(cell:CellServicesNamePrice, indexpath:IndexPath) -> UITableViewCell {
        let viewAtBack : UIView = (cell.viewWithTag(1))!
        viewAtBack.borderWidth = 1.0
        viewAtBack.borderColor = UIColor.lightGray.withAlphaComponent(0.4)
        viewAtBack.clipsToBounds=true
        viewAtBack.backgroundColor = (indexpath.row%2==0) ? UIColor.clear : UIColor.lightGray.withAlphaComponent(0.07)
        
        let data = (detail.appointmentDetails?.serviceNameArr?[indexpath.row])!
        cell.lblTitle.text = data.name
        cell.lblPrice.text = "$" + data.price!
        return cell
    }
    
    func configureCell(cell:UITableViewCell, indexpath:IndexPath) -> UITableViewCell {
        let viewAtBack : UIView = (cell.viewWithTag(1))!
        viewAtBack.borderWidth = 1.0
        viewAtBack.borderColor = UIColor.lightGray.withAlphaComponent(0.4)
        viewAtBack.clipsToBounds=true
        viewAtBack.backgroundColor = (indexpath.row%2==0) ? UIColor.clear : UIColor.lightGray.withAlphaComponent(0.07)
        let lblServiceName : UILabel = (cell.viewWithTag(2) as? UILabel)!
        let lblServicePrice : UILabel = (cell.viewWithTag(3) as? UILabel)!
        print(lblServiceName)
        print(lblServicePrice)
        return cell
    }
    
    func configureFeedbackCell(cell:CellFeedbackDetails, indexpath:IndexPath) -> UITableViewCell {
        switch indexpath.row {
        case 0:
            cell.lblTitle.text = "Your feedback to Provider"
            cell.lblReview.text = detail.rating?.providerMessage!
            if let rating = detail.rating?.providerRating {
                cell.ratingVw.rating = Double(rating)
            }
            break
        case 1:
            cell.lblTitle.text = "Provider feedback to you."
            cell.lblReview.text = detail.rating?.customerMessage!
            if let rating = detail.rating?.customerRating {
                cell.ratingVw.rating = Double(rating)
            }
            break
        default:
            break
        }
        return cell
    }
    
    func configureCellBarberDetailsList(cell:CellBarberDetailsList, indexpath:IndexPath) -> UITableViewCell {
        let userData = detail.appointmentDetails?.userDetails
        cell.imgVwUser.clipsToBounds=true
        cell.imgVwUser.layer.cornerRadius = 3.0
        cell.imgVwUser.layer.borderColor = UIColor.black.cgColor
        cell.imgVwUser.layer.borderWidth = 0.7
        cell.selectionStyle = .none
        
        cell.lblUserName.text = (userData?.firstname)!
        if !(userData?.profileImage?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: cell.imgVwUser.bounds.size.width/2, y: cell.imgVwUser.bounds.size.height/2)
            activityView.color = Constants.appColor.appColorMainPurple
            activityView.startAnimating()
            cell.imgVwUser.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (detail.imgUrl)! as String + (userData?.profileImage)! as String, completionHandler:{(image: UIImage?, url: String) in
                cell.imgVwUser.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        cell.btnChat.addTarget(self, action: #selector(chatAct), for: .touchUpInside)
        cell.btnCall.addTarget(self, action: #selector(callAct), for: .touchUpInside)
        cell.lblDistance.text  = "(\(userData?.distance ?? 0) miles away)"
        if let rating = userData?.rating {
            cell.ratingView.rating = Double(rating)!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if detail.appointmentDetails?.status != BookingStatus.completed.rawValue {
            if indexPath.section == 4 {
                return 0
            }
        }
        if indexPath.section == 0 || indexPath.section == 1 {
            return 50
        }
        return UITableViewAutomaticDimension
    }
    
    @objc func chatAct() {
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        newViewController.connection_id = (detail.appointmentDetails?.userDetails?.connection_id ?? 0)
        newViewController.receiver_id = detail.appointmentDetails?.userDetails?.id
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func callAct() {
        let phoneNo = self.detail.appointmentDetails?.userDetails?.phone
        if let url = URL(string: "tel://\(phoneNo ?? "0")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            Progress.instance.displayAlert(userMessage:"Your device doesn't support this feature.")
        }
    }
}

extension ServiceDetailsVC : CallbackCancelAppointment {
    func reloadAppointmentDetailData(reason: String) {
        detail.appointmentDetails?.status = BookingStatus.cancelled.rawValue
        detail.appointmentDetails?.cancelBy = Param.customer.rawValue
        detail.appointmentDetails?.cancelDescription = reason
       // DispatchQueue.main.async {
            self.setData()
       // }
        
     //   self.view.layoutIfNeeded()
    }
}
extension ServiceDetailsVC:reloadServiceDataProtocol{
    func reloadData() {
        getAppoitmentDetailAPI()
    }
}

class CellBarberDetailsList: UITableViewCell {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnChat: UIButton!
}

class CellFeedbackDetails: UITableViewCell {
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var ratingVw: FloatRatingView!
    @IBOutlet weak var lblTitle: UILabel!
}

class CellServicesNamePrice: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
}
