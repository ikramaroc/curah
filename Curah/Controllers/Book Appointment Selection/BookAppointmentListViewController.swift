//
//  BookAppointmentListViewController.swift
//  Curah
//
//  Created by Netset on 26/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper

class AppointmentListCell: UITableViewCell {
    @IBOutlet weak var listLbl: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
}

protocol passDataDelegate {
    func passData(data:[ServiceToSelect])
}


class BookAppointmentListViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    var servicesList : [ProviderServices] = []
    var selectUnselectArray = [Bool]()
    var textString : String!
    var delegate: passDataDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        listTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func configureTableView(){
        
        let array = textString.components(separatedBy: ",")
        
            for services in servicesList {
                if array.contains(services.name!){
                    self.selectUnselectArray.append(true)
                }else{
                    self.selectUnselectArray.append(false)
                }
        }
    }
    
    @IBAction func doneDismissBtnAction(_ sender: UIButton) {
        var servicesToBook = [ServiceToSelect]()
        for a in 0...servicesList.count-1
        {
            if selectUnselectArray[a] == true{
            let value = ServiceToSelect(name: servicesList[a].name!, price: servicesList[a].price!, id: servicesList[a].serviceId!)
            servicesToBook.append(value)
            }
        }
        
        delegate.passData(data: servicesToBook)
        self.dismiss(animated: true, completion: nil)
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BookAppointmentListViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "appointmentListCell") as! AppointmentListCell
        cell.listLbl.text = servicesList[indexPath.row].name!
        if selectUnselectArray[indexPath.row] == true{
            cell.checkBoxImageView.image = #imageLiteral(resourceName: "check_1")
        }else {
            cell.checkBoxImageView.image = #imageLiteral(resourceName: "uncheck_1")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectUnselectArray[indexPath.row] = (selectUnselectArray[indexPath.row] == true) ? false : true
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
}


