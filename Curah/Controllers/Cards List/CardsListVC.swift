//
//  CardsListVC.swift
//  QurahApp
//
//  Created by netset on 7/27/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class CardsListVC: BaseClass {
    
    
    var index : Int = 0
    var strScreenType : String = ""
    //    let data = ["Amex Ending in 3232" , "Visa Ending in 4254","Master Card Ending in 6675"]
    var cards = [Cards]()
    var baseUrl = String()
    var bookingId = 0
    var providerId = 0
    @IBOutlet weak var imgVwCardImage: UIImageView!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblEndingOn: UILabel!
    @IBOutlet weak var tblVwCards: UITableView!
    @IBOutlet weak var brnAddCardOut: UIButton!
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var topConst: NSLayoutConstraint!
    @IBOutlet var btnMakePaymentOut: UIButton!
    @IBOutlet weak var imgVwCardDummy: UIImageView!
    @IBOutlet weak var lblCardsTilte: UILabel!
    
    var isFromBooking = false
    var amount = 0
    var jobName = String()
    
    var isFromBookingAppointment = false
    var appointmentId = Int()
    var serviceId = String()
    var separatePrice = String()
    var address = String()
    var workDescription = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.setupBackBtn(tintClr: .white)
        self.tblVwCards.tableFooterView = UIView()
        self.setDetails()
        callCardListingAPI()
    }
    
    
    func setDetails() {
        btnMakePaymentOut.isHidden = false
        btnMakePaymentOut.alpha = 1
        if strScreenType == "myCards" {
            self.title = "My Cards"
            btnMakePaymentOut.setTitle("", for: .normal)
            btnMakePaymentOut.alpha = 0.6
            if cards.count == 0 {
                btnMakePaymentOut.isEnabled = false
                btnMakePaymentOut.alpha = 0.6
                imgVwCardDummy.isHidden=false
                lblCardsTilte.text = "    You have no cards in list."
            } else {
                self.setCardDetails(index: 0)
            }
        } else if strScreenType == "profile"{
            btnMakePaymentOut.isHidden = true
            self.title = "Payment Method"
        }
        else {
            imgBackground.isHidden=true
            self.view.backgroundColor = .clear
        }
    }
    
    
    
    func setCardDetails(index:Int) {
        
        if cards.count>0{
            lblEndingOn.text = cards[index].expYear
            lblCardNumber.text = "**** **** **** " + (cards[index].last4)!
            if !(cards[index].cardTypeImgUrl?.isEmpty)!{
                ImageLoader.sharedLoader.imageForUrl(urlString:baseUrl + (cards[index].cardTypeImgUrl)! as String, completionHandler:{(image: UIImage?, url: String) in
                    self.imgVwCardImage.image = image
                })
            }
        }else{
            lblEndingOn.text = ""
            lblCardNumber.text = ""
            self.imgVwCardImage.image = nil
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func btnAddCardAct(_ sender: Any) {
        self.performSegue(withIdentifier: "segueAddEditCard", sender: nil)
    }
    
    @IBAction func btnPaymentOrEditCardAct(_ sender: Any) {
        self.performSegue(withIdentifier: "segueAddEditCard", sender: cards[index])
    }
    
    
    
    @IBAction func makePaymentBtnAction(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "MAKE PAYMENT"{
            if cards.count == 0{
                Progress.instance.displayAlert(userMessage: "Please add card first")
            }else {
                
                if isFromBookingAppointment{
                    APIManager.sharedInstance.appointmentBookingAPI(appointmentId: appointmentId, serviceId: serviceId, price: amount , sepratePrice: separatePrice, providerId: providerId, address: address, workDescription: workDescription, paymentType: "S", cardId: cards[index].cardId!) { (response) in
                        
                        if response.status! == 404{
                            Progress.instance.displayAlert(userMessage: response.message!)
                            
                        }else if response.status! == 200{
                            Progress.instance.alertMessageWithActionOk(title: "Curah Customer", message: response.message!, action: {
                                
                                if self.navigationController != nil{
                                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                                    for aviewcontroller : UIViewController in viewControllers{
                                        if aviewcontroller.isKind(of: ProfileVC.self){
                                            
                                            self.navigationController?.popToViewController(aviewcontroller, animated: true)
                                            
                                        }
                                    }
                                }
                            })
                        }
                        
                        
                    }
                }else{
                    if providerId != 0 && bookingId != 0{
                        APIManager.sharedInstance.makePaymentAPI(bookingId: bookingId, cardId: cards[index].cardId!, providerId: providerId)  { (response) in
                            super.alertMessageWithActionOk(title: "Curah Customer", message: response.message!, viewcontroller: self, action: {
                                isFromPaymentScreen = true
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                    }
                }
            }
        }else{
          //  self.performSegue(withIdentifier: "segueAddEditCard", sender: cards[index])
        }
    }
    
    func deleteCard(cardId:Int){
        
        APIManager.sharedInstance.deleteCardAPI(cardId: cardId){ (response) in
            
            self.callCardListingAPI()
            //            super.alertMessageWithActionOk(title: "Curah Customer", message: response.message!, viewcontroller: self, action: {
            //
            //            })
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueAddEditCard" {
            let objVC : AddCardVC = segue.destination as! AddCardVC
            objVC.screenType = "inApp"
            objVC.objProtocol = self
            if sender != nil {
                objVC.cardDetail = sender as? Cards
            }
        }
    }
}

extension CardsListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CellPaymentList = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellPaymentList
        return self.configureCell(cell: cell, indexpath: indexPath)
    }
    
    func configureCell(cell:CellPaymentList, indexpath:IndexPath) -> UITableViewCell {
        let strCardName = " Ending in " + (cards[indexpath.row].last4)!
        let constantString = "Ending in"
        if indexpath.row == index {
            cell.imgVwTick.isHidden = false
            cell.lblTitle.text = strCardName
            cell.lblTitle.textColor = Constants.appColor.appColorMainGreen
        } else {
            cell.imgVwTick.isHidden = true
            cell.lblTitle.attributedText = self.changeFontColor(fullText: strCardName as NSString, strEndingText: constantString)
        }
        if !(cards[indexpath.row].cardTypeImgUrl?.isEmpty)!{
            ImageLoader.sharedLoader.imageForUrl(urlString: (cards[indexpath.row].cardTypeImgUrl)! as String, completionHandler:{(image: UIImage?, url: String) in
                DispatchQueue.main.async {
                    cell.imgVwCard.image = image
                }
            })
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func changeFontColor(fullText:NSString,strEndingText:String) -> NSAttributedString {
        let rangeOfServiceName = (fullText).range(of: strEndingText)
        let rangeOfFullText = (fullText).range(of: fullText as String)
        let attribute = NSMutableAttributedString.init(string: fullText as String)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black , range: rangeOfFullText)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray , range: rangeOfServiceName)
        return  attribute
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.setCardDetails(index:index)
        tblVwCards.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            deleteCard(cardId: cards[indexPath.row].cardId!)
            
            // handle delete (by removing the data from your array and updating the tableview)
        }
        
        
        
    }
    
}

class CellPaymentList: UITableViewCell {
    @IBOutlet weak var imgVwCard: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVwTick: UIImageView!
}

extension CardsListVC:CallbackOnCardListingScreen {
    func callCardListingAPI() {
        APIManager.sharedInstance.getCardListAPI() { (response) in
            self.cards = response.cards!
            self.baseUrl = response.url!
            self.setDetails()
            self.setCardDetails(index: 0)
            self.tblVwCards.reloadData()
        }
    }
}
