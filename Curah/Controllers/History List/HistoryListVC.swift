//
//  HistoryListVC.swift
//  QurahApp
//
//  Created by netset on 7/18/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import FloatRatingView
class HistoryListVC: BaseClass {
    
    
    @IBOutlet weak var tblVwHistory: UITableView!
    
    var modelBase : ModalBase?
    var historyDataDict = [Int:[Appointments]]()
    var sectionArray = [String]()
    fileprivate var noHistoryDataLbl = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setupMenuBarButton()
        self.title = "History"
        self.tblVwHistory.rowHeight = UITableViewAutomaticDimension
        self.tblVwHistory.estimatedRowHeight = 100
        self.tblVwHistory.sectionHeaderHeight = 50
        self.tblVwHistory.isHidden = true
        self.getHistoryList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.automaticallyAdjustsScrollViewInsets=false
    }
    
    //MARK:- get history list API *******
    func getHistoryList()  {
        APIManager.sharedInstance.getHistoryList(){ (response) in
            self.modelBase = response
            if (self.modelBase?.historyList?.count)! ==  0 {
                self.noDataLbl()
            } else {
                self.noHistoryDataLbl.isHidden = true
                self.tblVwHistory.isHidden = false
                self.filerHistoryData()
            }
            self.tblVwHistory.reloadData()
        }
    }
    
    func filerHistoryData() {
        let sortedByDate = self.modelBase?.historyList?.sorted { (History1, History2) -> Bool in
            return  super.convertToLocalDateFormatOnlyTimeToDate(utcDate:History1.date!).compare(super.convertToLocalDateFormatOnlyTimeToDate(utcDate: History2.date!)) == .orderedDescending
        }
        for dates in sortedByDate! {
            if !sectionArray.contains(dates.date!)  {
                sectionArray.append(dates.date!)
            }
        }
        for a in 0...sectionArray.count-1 {
            var tempArray = [Appointments]()
            for data in sortedByDate! {
                if sectionArray[a] == data.date! {
                    tempArray.append(data)
                }
            }
            self.historyDataDict[self.historyDataDict.count] = tempArray
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueServiceDetail" {
            let objVC : ServiceDetailsVC = segue.destination as! ServiceDetailsVC
            objVC.detail = sender as? ModalBase
        }
    }
    
    func noDataLbl()  {
        let originY = navigationController?.navigationBar.frame.maxY
        noHistoryDataLbl = UILabel(frame: CGRect(x: 0, y: originY! , width: self.view.frame.size.width, height: self.view.frame.size.height-originY!))
        noHistoryDataLbl.backgroundColor = UIColor.white
        noHistoryDataLbl.textColor = UIColor.black
        noHistoryDataLbl.font = UIFont(name: Constants.AppFont.fontAvenirRoman, size: 18)
        noHistoryDataLbl.text = "No history found"
        noHistoryDataLbl.isHidden = false
        noHistoryDataLbl.textAlignment = .center
        self.view.addSubview(noHistoryDataLbl)
        self.tblVwHistory.isHidden = true
    }
}

extension HistoryListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyDataDict[section] == nil {
            return 0
        } else {
            return historyDataDict[section]!.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
        cell.selectionStyle = .none
        cell.dateLbl.text = super.changeDateFormat(strDate: sectionArray[section])
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CellHistoryList = tableView.dequeueReusableCell(withIdentifier: "rowCell") as! CellHistoryList
        return self.configureCell(cell: cell, indexpath: indexPath)
    }
    
    func configureCell(cell:CellHistoryList, indexpath:IndexPath) -> UITableViewCell {
        cell.imgVw.clipsToBounds=true
        cell.imgVw.layer.cornerRadius = 4.0
        cell.imgVw.layer.borderColor = UIColor.black.cgColor
        cell.imgVw.layer.borderWidth = 0.7
        cell.selectionStyle = .none
        
        if (historyDataDict[indexpath.section]![indexpath.row].image?.count != 0) {
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: (cell.imgVw.bounds.size.width)/2, y: (cell.imgVw.bounds.size.height)/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            cell.imgVw.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (modelBase?.imgUrl)! as String + (historyDataDict[indexpath.section]![indexpath.row].image)!, completionHandler:{(image: UIImage?, url: String) in
                cell.imgVw.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        let list = historyDataDict[indexpath.section]![indexpath.row]
        cell.historyLbl.text = list.serviceName
        cell.serviceCostLbl.text = "Service cost :$" + "\(list.price!)"
        cell.timimgLbl.text = super.changeTimeFormat(strDate: list.startTime!) + " to " + super.changeTimeFormat(strDate: list.closeTime!)
        cell.userNameLbl.text = list.firstName! + "  " + list.lastName!
        cell.userDescriptionLbl.text = list.workDescription ?? ""
        if let rating = list.rating {
            cell.ratingVw.rating = Double(rating)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //self.performSegue(withIdentifier: "segueServiceDetail", sender: nil)
        let list = historyDataDict[indexPath.section]![indexPath.row]
        getAppoitmentDetailAPI(id: list.bookingId!)
    }
    
    // MARK:- Get AppoitmentDetail API
    func getAppoitmentDetailAPI(id:Int) {
        APIManager.sharedInstance.appointmentDetailAPI(bookingId: id) { (response) in
            self.performSegue(withIdentifier: "segueServiceDetail", sender: response)
        }
    }
    
}

class CellHistoryList: UITableViewCell {
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var historyLbl: UILabel!
    @IBOutlet weak var serviceCostLbl: UILabel!
    @IBOutlet weak var timimgLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userDescriptionLbl: UILabel!
    @IBOutlet weak var ratingVw: FloatRatingView!
}

class HeaderCell:UITableViewCell{
    @IBOutlet weak var dateLbl:UILabel!
}
