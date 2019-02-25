//
//  SelectPaymentMethodVC.swift
//  QurahApp
//
//  Created by netset on 7/23/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import Stripe

class SelectPaymentMethodVC: BaseClass {
       
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewSliderLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewSlider: UIView!
    @IBOutlet weak var viewSliderWidthConst: NSLayoutConstraint!
    @IBOutlet weak var btnApplePAy: UIButton!
    @IBOutlet weak var btnPaypal: UIButton!
    @IBOutlet weak var btnCards: UIButton!
    @IBOutlet weak var viewContinueWithPaypal: UIView!
    @IBOutlet weak var viewContinueWithApplePay: UIView!
    
    var bookingId = 0
    var providerId = 0
    var amount = 0
    var jobName = String()
    var fromProfile = false
    
    var isFromBookingAppointment = false
    var appointmentId = Int()
    var serviceId = String()
    var separatePrice = String()
    var address = String()
    var workDescription = String()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        mainView.isHidden=true
        super.setupBackBtn(tintClr: .white)
        viewContinueWithPaypal.isHidden=true
        viewContinueWithApplePay.isHidden=true
        self.setCornersForView(mainView: viewContinueWithApplePay)
        self.setCornersForView(mainView: viewContinueWithPaypal)
        DispatchQueue.main.async {
            self.viewSliderLeadingConst.constant = self.btnCards.frame.origin.x+self.stackView.frame.origin.x
            self.viewSliderWidthConst.constant = self.btnCards.frame.size.width
        }
        
        if fromProfile{
            self.title = "Payment Method"
        }
        
        hideShowViews(isApplepayHide: true, isPaypalHide: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CardsListVCIdentifier") {
            
            if isFromBookingAppointment{
                let obj = segue.destination as! CardsListVC
                obj.bookingId = bookingId
                obj.providerId = providerId
                obj.isFromBookingAppointment = true
                obj.amount = amount
                obj.separatePrice = separatePrice
                obj.address = address
                obj.workDescription = workDescription
                obj.appointmentId = appointmentId
                obj.serviceId = serviceId
                
             
                
            }else{
                let obj = segue.destination as! CardsListVC
                obj.bookingId = bookingId
                obj.providerId = providerId
                
                if fromProfile{
                    obj.strScreenType = "profile"
                }
                
            }
            
        }
       
    }
    
   
    
    @IBAction func tapOnApplePayAct(_ sender: Any) {
        doApplePayment()

    }
    
    func doApplePayment(){
        
        
        let merchantIdentifier = "merchant.curah.applePaytest"
        let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")
        
        // Configure the line items on the payment request
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label:jobName, amount: NSDecimalNumber(value: amount)),
            // The final line should represent your company;
            // it'll be prepended with the word "Pay" (i.e. "Pay iHats, Inc $50")
           // PKPaymentSummaryItem(label: "iHats, Inc", amount: 50.00),
        ]
        
        if Stripe.canSubmitPaymentRequest(paymentRequest) {
            // Setup payment authorization view controller
            let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            paymentAuthorizationViewController?.delegate = self
            
            // Present payment authorization view controller
            present(paymentAuthorizationViewController!, animated: true)
        }
        else {
            // There is a problem with your Apple Pay configuration
        }
    }
    
    

    @IBAction func tapOnPaypalAct(_ sender: Any) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnCardsAct(_ sender: Any) {
        mainView.isHidden=true
        self.hideShowViews(isApplepayHide: true, isPaypalHide: true)
        self.sliderViewSetUP(btn: btnCards)
    }
    
    @IBAction func btnPaypalAct(_ sender: Any) {
        mainView.isHidden=false
       // self.hideShowViews(isApplepayHide: true, isPaypalHide: false)
        self.sliderViewSetUP(btn: btnPaypal)
    }
    
    @IBAction func btnApplePayAct(_ sender: Any) {
        mainView.isHidden=false
       // self.hideShowViews(isApplepayHide: false, isPaypalHide: true)
        self.sliderViewSetUP(btn: btnApplePAy)
    }
    
    func hideShowViews(isApplepayHide:Bool, isPaypalHide:Bool)  {
        viewContinueWithPaypal.isHidden=isPaypalHide
        viewContinueWithApplePay.isHidden=isApplepayHide
        viewContinueWithPaypal.alpha=0.0
        viewContinueWithApplePay.alpha=0.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.showHideTransitionViews, animations: {
            if !isPaypalHide {
                self.viewContinueWithPaypal.alpha=1.0
             } else if !isApplepayHide {
                self.viewContinueWithApplePay.alpha=1.0
            }
           // self.view.layoutIfNeeded()
        })
    }
    
    func sliderViewSetUP(btn:UIButton) {
        self.viewSliderLeadingConst.constant = btn.frame.origin.x+stackView.frame.origin.x
        self.viewSliderWidthConst.constant = btn.frame.size.width
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func setCornersForView(mainView:UIView) {
        mainView.layer.cornerRadius=2
    }
}
extension SelectPaymentMethodVC:PKPaymentAuthorizationViewControllerDelegate{
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        STPAPIClient.shared().createToken(with: payment) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                return
            }
            print(token)
            
            APIManager.sharedInstance.applePayments(bookingId: self.bookingId,providerId:self.providerId, amount: self.amount,token:token.tokenId){ (response) in
              
                if response.status == 200{
                    completion(.success)
                    Progress.instance.displayAlert(userMessage: response.message!, completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }else{
                    completion(.failure)
                }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
    }
}
