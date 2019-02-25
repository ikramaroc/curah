//
//  BookAppointmentVC.swift
//  Curah
//
//  Created by Apple on 01/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import FSCalendar

class BookAppointmentVC: BaseClass {
    fileprivate var constantHeight : Int = 600
    fileprivate var selectedDate : String = ""
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    @IBOutlet var lblCurrentMonth: UILabel!
    @IBOutlet var lblCurrentYear: UILabel!
    @IBOutlet var calendar: FSCalendar!
    var objProtocol : updateViewSwipeHeight?
    let mnthsName = Calendar.current.monthSymbols
    @IBOutlet var lblTextMessage: UILabel!
    fileprivate var availableTimeSlots : [AvailableTimeSlots] = []
    var serviceId : Int!
    var providerId : Int?
    var date : String?
    var list : [ProviderServices] = []
    var servicesList : [ProviderServices] = []
    var appointmentId : Int?
    var userSelectedDate = String()
    var tableviewFooterHeight = CGFloat()
    
    @IBOutlet var tblVw: UITableView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCalendar()
        self.setLabelMessage(selectedDate:"")
         self.tblVw.tableFooterView?.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func setUpCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesUpperCase]
        calendar.appearance.weekdayTextColor = UIColor.black.withAlphaComponent(0.85)
        calendar.appearance.weekdayFont = UIFont(name: Constants.AppFont.fontAvenirMedium, size: 13.0)
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 12.0)
        calendar.calendarWeekdayView.backgroundColor = UIColor.init(hexString: "#F2F3F4")
        calendar.allowsMultipleSelection = false
        calendar.firstWeekday = 2
        calendar.headerHeight = 0
        calendar.weekdayHeight = 40
        calendar.appearance.selectionColor = Constants.appColor.appColorMainGreen
        self.setCurrentMonthInLabel()
        
        let formattedDate = super.getFormattedString(selectedDate: Date())
        userSelectedDate = formattedDate
        self.fetchAvailableDates(formattedDate: formattedDate)
        
    }
    
    func setLabelMessage(selectedDate:String) {
        if selectedDate.count == 0 && availableTimeSlots.count == 0 {
            self.lblTextMessage.text = "   Please select date to view available timeslots."
            //self.tblVwHeightConst.constant = CGFloat((self.availableTimeSlots.count+2) * 44)
        } else if selectedDate.count != 0 && availableTimeSlots.count == 0 {
            self.lblTextMessage.text = "   No timeslots available for a day."
            //self.tblVwHeightConst.constant = CGFloat((self.availableTimeSlots.count+2) * 44)
        } else {
            self.lblTextMessage.text = "   Green color time slots are opened."
            //self.tblVwHeightConst.constant = CGFloat((self.availableTimeSlots.count+2) * 44)
        }
        self.tblVw.reloadData()
     //   self.objProtocol?.updateHeight(value:self.constantHeight+Int(self.tblVw.frame.height))
    }
    
    func setCurrentMonthInLabel() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        lblCurrentYear.text = String(year)
        let month = calendar.component(.month, from: date)
        lblCurrentMonth.text = mnthsName[month-1]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.objProtocol?.updateHeight(value:self.constantHeight)
      //  objProtocol?.updateHeight(value:constantHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueBookAppointVC" {
            let objVC : BookAppointmentSelectionVC = segue.destination as! BookAppointmentSelectionVC
            objVC.servicesList = servicesList
            objVC.selectedDate = userSelectedDate
            objVC.serviceId = serviceId
            objVC.providerId = providerId
//            objVC.appointmentId = appoin
        }
    }
    

    @objc func btnBookAppointAct(_ sender: Any) {
        
        APIManager.sharedInstance.getPaymentStatus{ (response) in
           
            if response.status! == 200{
                 self.performSegue(withIdentifier: "segueBookAppointVC", sender: nil)
            }else if response.status! == 404 {
                Progress.instance.alertMessageWithActionOk(title: "Curah Customer", message: response.message!, action: {
                    
                    APIManager.sharedInstance.appointmentDetailAPI(bookingId: response.bookingId!) { (response) in
                        if response.status! == 200{
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ServiceDetailsVC") as! ServiceDetailsVC
                            obj.detail = response
                            self.navigationController?.pushViewController(obj, animated: true)
                        }else{
                            Progress.instance.displayAlert(userMessage:response.message! )
                        }
                        
                    }
                    
                })
            }
        

    }
    }
    
    func fetchAvailableDates(formattedDate:String) {
        APIManager.sharedInstance.viewAvailableTimeSlotsAPI(providerId: providerId!, date: formattedDate) { (response) in
            self.availableTimeSlots = response.timeSlotsAvailable!
            if self.availableTimeSlots.count>0{
                self.tableviewFooterHeight = 50
            }else{
                self.tableviewFooterHeight = 0.001
            }
            var intArray = [Int]()
            
            if self.availableTimeSlots.count != 0 {
                
                for a in 0...self.availableTimeSlots.count - 1{
                if self.availableTimeSlots[a].status! != "U"{
                    intArray.append(0)
                }else{
                    
                }
            }
            if intArray.count == self.availableTimeSlots.count {
                self.tableviewFooterHeight = 0.001
            }
            }
            
           // self.tblVwHeightConst.constant = CGFloat((self.availableTimeSlots.count+2) * 50)
         //   let height : Int = self.constantHeight+Int(self.tblVwHeightConst.constant)
         //   let width : Int = Int(self.view.frame.width)
         //   self.contentVw.frame.size = CGSize(width: width, height:30000)
          //  self.scroolVw.frame = CGRect(x: 0, y: 0, width: width, height:30000)
          //  self.scroolVw.contentSize = CGSize(width: 375, height: 30000) // You can set height, whatever you want.

            
        //    self.tblVw.layoutIfNeeded()
            self.setLabelMessage(selectedDate: formattedDate)
        }
    }
}


extension BookAppointmentVC :  FSCalendarDataSource {
    // MARK:- FSCalendarDataSource
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        lblCurrentMonth.text = mnthsName[month-1]
        let year = Calendar.current.component(.year, from: currentPageDate)
        lblCurrentYear.text = String(year)
    }
}


extension BookAppointmentVC :  FSCalendarDelegate {
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        //self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formattedDate = super.getFormattedString(selectedDate: date)
        userSelectedDate = formattedDate
        if selectedDate != formattedDate {
            selectedDate = formattedDate
           self.fetchAvailableDates(formattedDate: formattedDate)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        // print("did deselect date \(self.formatter.string(from: date))")
        // self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
}

extension BookAppointmentVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableTimeSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell")
        return self.configureCell(cell: cell!, indexpath: indexPath)
    }
    
    func configureCell(cell:UITableViewCell, indexpath:IndexPath) -> UITableViewCell {
        cell.indentationLevel = 1
        let list = self.availableTimeSlots[indexpath.row]
        if list.status == "U" {
            cell.textLabel?.textColor = Constants.appColor.appColorMainGreen
        } else {
            cell.textLabel?.textColor = UIColor.lightGray
        }
        cell.textLabel?.text = "\(super.changeTimeFormat(strDate: list.startTime!)) - " +  "\(super.changeTimeFormat(strDate: list.closeTime!))"
        cell.textLabel?.font = UIFont(name: Constants.AppFont.fontAvenirRoman, size: 14.0)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableviewFooterHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "footerCell")
        let btn = cell?.viewWithTag(1) as? UIButton
        btn?.addTarget(self, action: #selector(btnBookAppointAct), for: .touchUpInside)
        return cell?.contentView
    }
    
}
