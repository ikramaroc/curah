//
//  ReceiptVC.swift
//  Curah Provider
//
//  Created by Netset on 31/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit

struct ReceiptArray {
    var name:String!
    var price:Int!
}


class ReceiptVC: BaseClass,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taxAmountLbl: UILabel!
    @IBOutlet weak var serviceFeeLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    var feedbackDataDict: CustomerAppointments!
    
    
    var payablePrice = Double()
    var totalPrice = Int()
    var array = [Keywords]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarWithBackBtnAndTitle(title: "Receipt")
        setPrice()
    }
    
    func setPrice(){
        array = feedbackDataDict.serviceNameArr!
        let servicefeetax: Double = 5.0
        let fivepercent:Double
        totalPrice = feedbackDataDict.price!
        //totalPrice = Int(257.0)
        fivepercent = servicefeetax * Double(totalPrice)/100
        let strService = String(Double(fivepercent))
        let first3 = String(strService.prefix(5))
        if first3.count == 4{
        serviceFeeLbl.text = "$\(String(first3) + "0")"
        }else{
            serviceFeeLbl.text = "$\(String((first3)))"
        }
        
        let tax: Double = 8.5
        var aboveightpercetn : Double
        aboveightpercetn = tax * Double(totalPrice)/100
        let strTax = String(Double(aboveightpercetn))
        let first4 = String(strTax.prefix(5))
        if first4.count == 4{
            taxAmountLbl.text = "$\(String(first4) + "0")"
        }else{
            taxAmountLbl.text = "$\(String((first4)))"
            
        }
        
        let result = (Double(strService)!) + (Double(strTax)!) + Double(totalPrice)
        let doubleStr = String(format: "%.2f", result)
        totalPriceLbl.text = "$\(doubleStr)"
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return array.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReceiptCell
        cell.selectionStyle = .none
        cell.lblService.text = array[indexPath.row].name!
        // cell.lblPrice.text = "$\(array[indexPath.row].price!)"
        cell.lblPrice.text = array[indexPath.row].price!
        return cell
    }
}

class ReceiptCell: UITableViewCell {
    
    @IBOutlet weak var lblService :UILabel!
    @IBOutlet weak var lblPrice :UILabel!
    
    
}
