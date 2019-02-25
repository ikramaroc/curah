    //
    //  BookAppointmentVC.swift
    //  BookAppointmentVc
    //
    //  Created by netset on 01/08/18.
    //  Copyright © 2018 netset. All rights reserved.
    //
    
    import UIKit
    import GooglePlaces
    import CoreLocation
    import IQKeyboardManagerSwift
    import KMPlaceholderTextView
    
    struct ServiceToSelect {
        var name :String
        var price :Int
        var id :Int
    }
    
    class BookAppointmentSelectionVC: BaseClass,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
        
        // ----------------------------------
        //  MARK: - IB-OUTLET(S)
        //
        @IBOutlet weak var priceLbl: UILabel!
        @IBOutlet var tblVwHeightConst: NSLayoutConstraint!
        @IBOutlet weak var viewApproxCost: UIView!
        @IBOutlet fileprivate weak var tableVwBookAppointment: UITableView!
        @IBOutlet weak var contentView: UIView!
        @IBOutlet weak var lblAddressHint: UILabel!
        @IBOutlet weak var txtSelectDate: UCTextFld!
        @IBOutlet weak var txtSelectServices: UCTextFld!
        @IBOutlet weak var txtSelectTime: UCTextFld!
        @IBOutlet weak var txtEnterAddress: UILabel!
        @IBOutlet weak var constraintHeightTextView: NSLayoutConstraint!
        @IBOutlet weak var descriptionTxt: KMPlaceholderTextView!
        @IBOutlet weak var taxAmountLbl: UILabel!
        
        @IBOutlet weak var serviceFeeLbl: UILabel!
        
        
        fileprivate var availableTimeSlots : [AvailableTimeSlots] = []
        var selectedDate = String()
        var locManager = CLLocationManager()
        var currentLocation: CLLocation!
        var pickerViewService = UIPickerView()
        var pickerViewTime = UIDatePicker()
        var pickerViewDate = UIDatePicker()
        var serviceId : Int!
        var separatedPriceStr = String()
        var serviceIds = String()
        var orignalAmount = Int()
        var servicesList : [ProviderServices] = []
        var selectedServices : [ProviderServices] = []
        
        var providerId : Int?
        var appointmentId : Int?
        fileprivate var servicesToBook : [ServiceToSelect] = []
        fileprivate var totalPrice : Int = 0
        // var arrayServices = ["Blow Out","Hair Color","Haircut","Eyebrow Shaping"]
        
        // ----------------------------------
        //  MARK: - CONSTANT(S)
        //
        struct Identifiers {
            enum Cell:String {
                case tableCellBookAppointment = "BookAppointmentTableCell"
            }
        }
        
        // ----------------------------------
        //  MARK: - LIFE CYCLE(S)
        //
        override func viewDidLoad() {
            super.viewDidLoad()
            self.rigisterNibCell()
            super.underLineTextFldBottomLine(mainView: contentView)
            let iconsSize = CGRect(x: 0, y: 0, width: 10, height: 10)
            let emojisCollection = [UIImage(named: "address_grey")]
            tblVwHeightConst.constant = 0
            let attributedString = NSMutableAttributedString(string: "Use current address by tapping on")
            let loveAttachment = NSTextAttachment()
            loveAttachment.image = emojisCollection[0]
            loveAttachment.bounds = iconsSize
            attributedString.append(NSAttributedString(attachment: loveAttachment))
            attributedString.append(NSAttributedString(string: " icon."))
            lblAddressHint.attributedText = attributedString
            lblAddressHint.font = UIFont.systemFont(ofSize: 12)
            
            selectedServices = servicesList
            addViewShadow(btn: viewApproxCost)
            
            txtSelectTime.inputView = pickerViewService
            txtSelectServices.delegate = self
            
            pickerViewService.dataSource = self
            pickerViewService.delegate = self
            
            
            txtSelectDate.inputView = pickerViewDate
            
            //            pickerViewTime.addTarget(self, action: #selector(selectTime(_:)), for: .valueChanged)
            pickerViewDate.addTarget(self, action: #selector(selectDate(_:)), for: .valueChanged)
            pickerViewTime.datePickerMode = .time
            pickerViewDate.datePickerMode = .date
            
            
            setNavigationBarWithBackBtnAndTitle(title: "Book Appointment")
            self.setInitialService()
            
            if servicesToBook.count > 0{
                
                priceLbl.text = "$\(servicesToBook[0].price)"
                orignalAmount = servicesToBook[0].price
                taxAmountLbl.text = ""
                separatedPriceStr = "\(servicesToBook[0].price)"
                serviceIds = "\(servicesToBook[0].id)"
            }
            
            if selectedDate.count>0{
                
                getAppointmentsOfSelectedDate(dateStr: selectedDate, providerId: providerId!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let date = dateFormatter.date(from: selectedDate)
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                txtSelectDate.text = dateFormatter.string(from: date!)
            }
        }
        
        
        
        @IBAction func selectServicesBtnAction(_ sender: UIButton) {
            
            let viewController  =     self.storyboard!.instantiateViewController(withIdentifier: "BookAppointmentListViewController") as! BookAppointmentListViewController
            viewController.servicesList = servicesList
            viewController.delegate = self
            viewController.textString = txtSelectServices.text
            viewController.providesPresentationContextTransitionStyle = true
            viewController.definesPresentationContext = true
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true, completion: nil)
        }
        
        
        func setInitialService() {
            let item = servicesList.filter{$0.serviceId == serviceId }
            
            if item.count > 0 {
                print(item)
                let value  = ServiceToSelect(name: item[0].name!, price: item[0].price!, id: item[0].serviceId!)
                servicesToBook.append(value)
                self.tableVwBookAppointment.reloadData()
                txtSelectServices.text = value.name
            }
        }
        
        func addServicesToList() {
            
        }
        
        func addViewShadow(btn:UIView) {
            DispatchQueue.main.async {
                btn.layer.shadowColor = UIColor.init(hexString: "#C696AE").cgColor
                btn.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
                btn.layer.shadowOpacity = 0.4
                btn.layer.shadowRadius = 4.0
                btn.layer.cornerRadius = 2
                btn.layer.masksToBounds = false
            }
        }
        
        
        // ----------------------------------
        //  MARK: - OVERRIDE METHOD(S)
        //
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        // ----------------------------------
        //  MARK: - PRIVATE METHOD(S)
        //
        private func rigisterNibCell(){
            tableVwBookAppointment.register(UINib(nibName: Identifiers.Cell.tableCellBookAppointment.rawValue, bundle: nil), forCellReuseIdentifier: Identifiers.Cell.tableCellBookAppointment.rawValue)
            
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            
            if txtSelectTime.isFirstResponder{
                return availableTimeSlots.count
            }else{
                return selectedServices.count
            }
            return 0
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if txtSelectTime.isFirstResponder{
                let list = self.availableTimeSlots[row]
                return "\(super.changeTimeFormat(strDate: list.startTime!)) - " +  "\(super.changeTimeFormat(strDate: list.closeTime!))"
            }else{
                return  selectedServices[row].name
            }
            
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if txtSelectTime.isFirstResponder{
                
                if availableTimeSlots.count == 0{
                    
                }else{
                    let list = self.availableTimeSlots[row]
                    
                    txtSelectTime.text = "\(super.changeTimeFormat(strDate: list.startTime!)) - " +  "\(super.changeTimeFormat(strDate: list.closeTime!))"
                    appointmentId = list.appointmentTimeId
                }
                
               
            }else{
                txtSelectServices.text = selectedServices[row].name
            }
            
        }
        
        //       @objc func selectTime(_ sender:UIDatePicker){
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateFormat = "hh:mm a"
        //            txtSelectTime.text = dateFormatter.string(from: sender.date)
        //
        //        }
        
        @objc func selectDate(_ sender:UIDatePicker){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            txtSelectDate.text = dateFormatter.string(from: sender.date)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            getAppointmentsOfSelectedDate(dateStr: dateFormatter.string(from: sender.date), providerId: providerId!)
        }
        
        
        
        @IBAction func btnCurrenAddress(_ sender: UIButton) {
            locManager.requestWhenInUseAuthorization()
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                currentLocation = locManager.location
                print(currentLocation.coordinate.latitude)
                print(currentLocation.coordinate.longitude)
                getAddressFromLatLon(pdblLatitude: "\(currentLocation.coordinate.latitude)", withLongitude: "\(currentLocation.coordinate.longitude)")
            }
        }
        
        
        
        
        func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country ?? "")
                        print(pm.locality ?? "")
                        print(pm.subLocality ?? "")
                        print(pm.thoroughfare ?? "")
                        print(pm.postalCode ?? "")
                        print(pm.subThoroughfare ?? "")
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        self.txtEnterAddress.text = addressString
                    }
            })
        }
        
        
        
        func getAppointmentsOfSelectedDate(dateStr:String,providerId:Int){
            APIManager.sharedInstance.getAppointmentSessions(providerId: providerId, date:dateStr ){ (response) in
                //                self.txtSelectTime.becomeFirstResponder()
                
                if response.timeSlotsAvailable!.count > 0{
                    for timeSlot in response.timeSlotsAvailable!{
                        if timeSlot.status! == "U"{
                            self.availableTimeSlots.append(timeSlot)
                        }
                    }
                }
                
                if self.availableTimeSlots.count == 0{
                    self.txtSelectTime.text = "No sessions available"
                } else {
                    self.txtSelectTime.text = ""
                    self.pickerViewService.reloadAllComponents()
                }
            }
        }
        
        @IBAction func submitBtnAction(_ sender: UIButton) {
            
            if self.txtSelectTime.text == "No sessions available" || self.txtSelectTime.text?.count == 0 {
                Progress.instance.displayAlert(userMessage:Validation.call.noSessionAvailable)
            }else if self.priceLbl.text?.count == 0 {
                Progress.instance.displayAlert(userMessage:Validation.call.selectASession)
            }else{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier:"SelectPaymentMethodVC") as!  SelectPaymentMethodVC
                vc.isFromBookingAppointment = true
                vc.amount =  orignalAmount
                vc.appointmentId = appointmentId!
                vc.serviceId = serviceIds
                vc.separatePrice = separatedPriceStr
                vc.providerId = providerId!
                vc.address = txtEnterAddress.text!
                vc.workDescription = descriptionTxt.text!
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                
                
                // bookAppointmentForSelectedDateTime(session: self.txtSelectTime.text!)
            }
        }
        
        //        func bookAppointmentForSelectedDateTime(session:String) {
        //            APIManager.sharedInstance.appointmentBookingAPI(appointmentId: appointmentId!, serviceId: serviceIds, price: removeSpecialCharsFromString(text: priceLbl.text!) , sepratePrice: separatedPriceStr, providerId: providerId!, address: txtEnterAddress.text!, workDescription: descriptionTxt.text) { (response) in
        //                Progress.instance.alertMessageOkWithBack(title: "", message: response.message!, viewcontroller: self)
        //
        //                }
        //        }
        
        
        @IBAction func btnSelectAddress(_ sender: UIButton) {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            
            let filter = GMSAutocompleteFilter()
            filter.type = .address
            filter.country = "USA"
            autocompleteController.autocompleteFilter = filter
            
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    
    extension BookAppointmentSelectionVC:passDataDelegate{
        func passData(data: [ServiceToSelect]) {
            servicesToBook = data
            tableVwBookAppointment.reloadData()
            tblVwHeightConst.constant = CGFloat(50 * servicesToBook.count)
            separatedPriceStr = ""
            var text = [String]()
            var ids = [String]()
            var priceStr = [String]()
            var price = 0
            for a in servicesToBook {
                text.append(a.name)
                price = price + a.price
                priceStr.append("\(a.price)")
                ids.append("\(a.id)")
            }
            serviceIds = ids.joined(separator: ",")
            txtSelectServices.text = text.joined(separator: ",")
            orignalAmount = price
            let taxPrice = Double(Double(price) * 0.085)
            let serviceFee = Double(Double(price) * 0.05)
            let updatedPrice = Double(round(100*taxPrice)/100)
            let serviceFeeFinal = Double(round(100*serviceFee)/100)
            let finalPrice = Double(updatedPrice) + Double(price) + Double(serviceFee)
            let finalPriceFinal = Double(round(100*finalPrice)/100)
            priceLbl.text = "$\(finalPriceFinal)"
            taxAmountLbl.text = "$\(updatedPrice)"
            serviceFeeLbl.text = "$\(serviceFeeFinal)"
            separatedPriceStr = priceStr.joined(separator: ",")
        }
        
    }
    
    
    // ----------------------------------
    //  MARK: - Table View DataSource
    //
    extension BookAppointmentSelectionVC: UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return servicesToBook.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let cell = tableVwBookAppointment.dequeueReusableCell(withIdentifier: Identifiers.Cell.tableCellBookAppointment.rawValue, for: indexPath) as! BookAppointmentTableCell
            cell.lblServiceName.text = servicesToBook[indexPath.row].name
            cell.btnCross.isHidden = true
            cell.lblServicePrice.text = "$\(servicesToBook[indexPath.row].price)"
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(deleteCells), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }
        
        @objc  func deleteCells(sender:UIButton){
            servicesToBook.remove(at: sender.tag)
            tableVwBookAppointment.reloadData()
            tblVwHeightConst.constant = CGFloat(50 * servicesToBook.count)
            var text = [String]()
            var price = 0
            
            if servicesToBook.count > 0{
                for a in servicesToBook {
                    text.append(a.name)
                    price = price + a.price
                }
                txtSelectServices.text = text.joined(separator: ",")
                priceLbl.text = "$\(price)"
                orignalAmount = price
                taxAmountLbl.text = ""
            }else{
                txtSelectServices.text = ""
                priceLbl.text = ""
                orignalAmount = 0
                taxAmountLbl.text = ""
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Table View Delegate
    //
    extension BookAppointmentSelectionVC: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }
    }
    extension BookAppointmentSelectionVC: GMSAutocompleteViewControllerDelegate {
        
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            print("Place name: \(place.name)")
            print("Place address: \(String(describing: place.formattedAddress))")
            print("Place attributions: \(String(describing: place.attributions))")
            txtEnterAddress.text = place.formattedAddress
            dismiss(animated: true, completion: nil)
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
        }
        
        // User canceled the operation.
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            dismiss(animated: true, completion: nil)
        }
        
        // Turn the network activity indicator on and off again.
        func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        
    }
    
    extension BookAppointmentSelectionVC : UITextViewDelegate {
        func textViewDidChange(_ textView: UITextView) {
            self.textViewNotasChange(textVw:textView)
        }
        
        func textViewNotasChange(textVw:UITextView) {
            textVw.translatesAutoresizingMaskIntoConstraints = true
            textVw.sizeToFit()
            textVw.isScrollEnabled = false
            let calHeight = textVw.frame.size.height
            textVw.frame = CGRect(x: txtSelectServices.frame.origin.x, y: textVw.frame.origin.y, width: txtSelectServices.frame.size.width, height: calHeight)
            if calHeight > 40 {
                constraintHeightTextView.constant = calHeight
            } else {
                constraintHeightTextView.constant = 40
            }
            textVw.translatesAutoresizingMaskIntoConstraints=false
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if (text == "\n") {
                textView.resignFirstResponder()
            }
            return true
        }
    }
