//
//  RateReviewPopUpVC.swift
//  QurahApp
//
//  Created by netset on 7/23/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import FloatRatingView
import KMPlaceholderTextView

protocol  reloadServiceDataProtocol {
    func reloadData()
}

class RateReviewPopUpVC: UIViewController {
    
    @IBOutlet weak var textVwMessage: KMPlaceholderTextView!
    @IBOutlet var ratingVw: FloatRatingView!
    var otherUserId = Int()
    var bookingId = Int()
    var delegate : reloadServiceDataProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validation(){
        
        if textVwMessage.text.count == 0{
            Progress.instance.displayAlert(userMessage:Validation.call.enterDescriptionText)
        }else{
            self.submitRatingApi()
        }
        
    }
    
    func submitRatingApi(){
        APIManager.sharedInstance.giveRatingAPI(otherUserId: otherUserId, bookingId: bookingId, ratingValue: Int(ratingVw.rating), description: textVwMessage.text!) { (response) in
             self.delegate.reloadData()
            Progress.instance.displayAlert(userMessage: response.message!)
            self.dismiss(animated: true, completion: nil)
        }
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
        validation()
    }
}
