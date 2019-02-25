//
//  MyAppointmentVC.swift
//  QurahApp
//
//  Created by netset on 7/30/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import FSCalendar

class MyAppointmentVC: BaseClass {
    fileprivate var selectedDates : [String] = []
    fileprivate var myAppointmentList : [CustomerAppointments] = []
    fileprivate var filteredAppointmentList : [CustomerAppointments] = []
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    @IBOutlet weak var lblCurrentMonth: UILabel!
    @IBOutlet weak var lblCurrentYear: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tblVwAppointments: UITableView!
    let mnthsName = Calendar.current.monthSymbols
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setupMenuBarButton()
        self.title = "My Appointments"
        tblVwAppointments.estimatedRowHeight = 60
        self.setUpCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.appoitmentList()
    }
    
    func setUpCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesUpperCase]
        calendar.appearance.weekdayTextColor = UIColor.black.withAlphaComponent(0.85)
        calendar.appearance.weekdayFont = UIFont(name: Constants.AppFont.fontAvenirMedium, size: 13.0)
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 12.0)
        calendar.calendarWeekdayView.backgroundColor = UIColor.init(hexString: "#F2F3F4")
        calendar.allowsMultipleSelection = true
        calendar.firstWeekday = 2
        calendar.headerHeight = 0
        calendar.weekdayHeight = 40
        calendar.appearance.selectionColor = Constants.appColor.appColorMainGreen
        self.setCurrentMonthInLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCurrentMonthInLabel() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        lblCurrentYear.text = String(year)
        let month = calendar.component(.month, from: date)
        lblCurrentMonth.text = mnthsName[month-1]
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.detail.rawValue {
            let objVC : ServiceDetailsVC = segue.destination as! ServiceDetailsVC
            objVC.detail = sender as? ModalBase
        } else if segue.identifier == segueId.cancelAppointment.rawValue {
            let objVC : CancelAppointmentPopupVC = segue.destination as! CancelAppointmentPopupVC
             objVC.objProtocol = self
            objVC.bookingId = sender as! Int
        }
    }
    
    // MARK:- Reviews List API
    func appoitmentList() {
        APIManager.sharedInstance.getAppointmentListAPI() { (response) in
            self.myAppointmentList = response.customerAppointments!
            self.filteredAppointmentList = self.myAppointmentList
            self.tblVwAppointments.reloadData()
        }
    }
}

extension MyAppointmentVC : CallbackCancelAppointment {
    func reloadAppointmentDetailData(reason: String) {
        self.appoitmentList()
    }
}

extension MyAppointmentVC :  FSCalendarDataSource {
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


extension MyAppointmentVC :  FSCalendarDelegate {
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
        print(date)
        self.getFilteredData(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        self.getFilteredData(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }

    func getFilteredData(date: Date) {
        let formattedDate = super.getFormattedString(selectedDate: date)
        if !selectedDates.contains(formattedDate) {
            selectedDates.append(formattedDate)
        } else {
            selectedDates.remove(at: selectedDates.index(of: formattedDate)!)
        }
        self.filteredAppointmentList.removeAll()
        for index in 0..<selectedDates.count {
            var filtered : [CustomerAppointments] = []
            filtered = (self.myAppointmentList.filter {$0.date!.range(of: selectedDates[index], options: [.anchored, .caseInsensitive, .diacriticInsensitive]) != nil })
            self.filteredAppointmentList += filtered
        }
        self.tblVwAppointments.reloadData()
    }
}

extension MyAppointmentVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.filteredAppointmentList.count == 0) ? 1 : self.filteredAppointmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.filteredAppointmentList.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell")
            return cell!
        }
        let cell : CellAppointmentList = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellAppointmentList
        return self.configureCell(cell: cell, indexpath: indexPath)
    }
    
    func configureCell(cell:CellAppointmentList, indexpath:IndexPath) -> UITableViewCell {
        cell.selectionStyle = .none
        super.setUpButtonShadow(btn: cell.btnCancelAppointmentOut)
        let list = self.filteredAppointmentList[indexpath.row]
        cell.lblDateTime.text = super.changeDateFormat(strDate: list.date!)
        cell.lblServicesName.text = list.serviceName
        cell.btnHeightConst.constant = 35
        cell.btnCancelAppointmentOut.isHidden=false
        cell.lblServiceStatus.textColor = UIColor.black.withAlphaComponent(0.9)
        cell.btnCancelAppointmentOut.tag = list.bookingId!
        cell.btnCancelAppointmentOut.addTarget(self, action: #selector(cancelAppoinmentAct), for: .touchUpInside)
        switch list.status {
        case BookingStatus.inProgress.rawValue:
            cell.lblServiceStatus.text = "In-Progress"
            cell.btnHeightConst.constant = 0
            cell.btnCancelAppointmentOut.isHidden=true
            cell.lblServiceStatus.textColor = Constants.appColor.appColorMainGreen
            break
        case BookingStatus.accept.rawValue:
            cell.lblServiceStatus.text = "Accepted"
            break
        case BookingStatus.reject.rawValue:
            cell.lblServiceStatus.text = "Rejected"
            break
        case BookingStatus.waiting.rawValue:
            cell.lblServiceStatus.text = "Waiting for response"
            break
        case BookingStatus.cancelled.rawValue:
            cell.btnHeightConst.constant = 0
            cell.btnCancelAppointmentOut.isHidden=true
            cell.lblServiceStatus.text = (list.cancelBy == Param.customer.rawValue) ? "Cancelled by me"  :  "Cancelled by provider"
            break
        default:
            cell.lblServiceStatus.text = "Status not defined"
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.filteredAppointmentList.count == 0) ? self.tblVwAppointments.frame.size.height : UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = self.filteredAppointmentList[indexPath.row]
        self.getAppoitmentDetailAPI(id: list.bookingId!)
    }
    
     // MARK:- Get AppoitmentDetail API
    func getAppoitmentDetailAPI(id:Int) {
        APIManager.sharedInstance.appointmentDetailAPI(bookingId: id) { (response) in
            self.performSegue(withIdentifier: segueId.detail.rawValue, sender: response)
        }
    }
    
    @objc func cancelAppoinmentAct(sender: UIButton){
        
        let newVc = self.storyboard?.instantiateViewController(withIdentifier: "CancelAppointmentPopupVC") as! CancelAppointmentPopupVC
        newVc.objProtocol = self
        newVc.bookingId = sender.tag
        
        newVc.providesPresentationContextTransitionStyle = true
        newVc.definesPresentationContext = true
        newVc.modalPresentationStyle = .overCurrentContext
        self.present(newVc, animated: true, completion: nil)
        
//        self.performSegue(withIdentifier: segueId.cancelAppointment.rawValue, sender: sender.tag)
    }
}

class CellAppointmentList: UITableViewCell {
    @IBOutlet weak var btnCancelAppointmentOut: UIButton!
    @IBOutlet weak var lblServiceStatus: UILabel!
    @IBOutlet weak var lblServicesName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnHeightConst: NSLayoutConstraint!
}
