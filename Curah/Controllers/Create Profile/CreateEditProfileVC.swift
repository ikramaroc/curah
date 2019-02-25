//
//  CreateEditProfileVC.swift
//  QurahApp
//
//  Created by netset on 7/25/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import AVFoundation
import MapKit
import GoogleMaps

class CreateEditProfileVC: BaseClass {
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var textFldDateOfBirth: UITextField!
    @IBOutlet weak var btnPickPhoto: UCButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnCreateProfileOut: UIButton!
    @IBOutlet weak var lblUploadPicText: UILabel!
    @IBOutlet weak var textFldFirstName: UCTextFld!
    @IBOutlet weak var textFldLastName: UCTextFld!
    @IBOutlet weak var textFldDateOfBith: UCTextFld!
    @IBOutlet weak var textFldMobileNo: UCTextFld!
    
    var locationCoordinate = CLLocationCoordinate2D()
    var birthDate : String = ""
    var cityName = String()
    var stateName = String()
    var datePicker = UIDatePicker()
    var strScreenType : String = "edit"
    var isImageAdded : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.underLineTextFldBottomLine(mainView: contentView)
        self.textFldDateOfBirthAction()
        if strScreenType == "edit" {
            super.setupBackBtn(tintClr: .white)
            self.title = "Edit Profile"
            self.setUpData()
        } else {
            self.setUpDataDuringCreateProfile()
            setNavigationBarWithBackBtnAndTitle(title: "Create Profile")
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        
    }
    
    func setUpDataDuringCreateProfile() {
        if ModalShareInstance.shareInstance.modalUserData != nil {
            let data = ModalShareInstance.shareInstance.modalUserData.userInfo
            textFldFirstName.text = data?.firstname
            textFldLastName.text = data?.lastname
            if data?.profileImageUrl != nil {
                DispatchQueue.global(qos: .background).async {
                    do {
                        let data = try? Data(contentsOf: (data?.profileImageUrl)!)
                        DispatchQueue.main.async {
                            if let imgData = data {
                                let image: UIImage = UIImage(data: imgData)!
                                self.btnPickPhoto.setBackgroundImage(image, for: .normal)
                                self.isImageAdded=true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setUpData()  {
        let userInfo = ModalShareInstance.shareInstance.modalUserData.userInfo
        textFldFirstName.text = userInfo?.firstname
        textFldLastName.text = userInfo?.lastname
        textFldDateOfBith.text = super.changeBirthDateFormat(strDate: (userInfo?.dob)!)
        birthDate = (userInfo?.dob)!
        lblAddress.text = userInfo?.address
        textFldMobileNo.text = userInfo?.phone
        lblUploadPicText.text = "Change Profile Picture"
        
        btnPickPhoto.setImage(nil, for: .normal)
        btnCreateProfileOut.setTitle("UPDATE PROFILE", for: .normal)

        if !(userInfo?.profileImage?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: btnPickPhoto.bounds.size.width/2, y: btnPickPhoto.bounds.size.height/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            btnPickPhoto.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (userInfo?.profileImageUrlApi)! as String + (userInfo?.profileImage)! as String, completionHandler:{(image: UIImage?, url: String) in
                self.btnPickPhoto.setBackgroundImage(image, for: .normal)
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
    }
    
    func textFldDateOfBirthAction() {
        textFldDateOfBirth.inputView = datePicker
        datePicker.set13YearValidation()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerAct), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterLocationAct(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "USA"
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc  func datePickerAct(sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        self.textFldDateOfBirth.text = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthDate = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func btnPickPhoto(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            self.showOptions()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.showOptions()
                    //access allowed
                } else {
                    //access denied
                    self.alertPromptToAllowCameraAccessViaSetting()
                }
            })
        }
    }
    
    func showOptions() {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(title: "Error", message: "Access required to capture photo", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        present(alert, animated: true)
    }
    
    @IBAction func btnCreateProfileAct(_ sender: Any) {
        self.Validations()
        
    }
    
    func Validations() {
        if textFldFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.displayAlert(userMessage: Validation.call.firstName)
        } else if textFldDateOfBirth.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.displayAlert(userMessage: Validation.call.dob)
        }  else if lblAddress.text == "Enter Your Address" {
            self.displayAlert(userMessage: Validation.call.enterAddress)
        } else if textFldMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.displayAlert(userMessage: Validation.call.phone)
        } else if btnPickPhoto.backgroundImage(for: .normal) == #imageLiteral(resourceName: "profile"){
            self.displayAlert(userMessage: Validation.call.photo)
        } else {
            self.createProfileAPI()
        }
    }
    
    func createProfileAPI() {
        
        if cityName.count == 0{
            cityName = ModalShareInstance.shareInstance.modalUserData.userInfo?.city ?? ""
        }
        if stateName.count == 0 {
            stateName = ModalShareInstance.shareInstance.modalUserData.userInfo?.state ?? ""
        }
        
        APIManager.sharedInstance.createProfileAPI(frstName: textFldFirstName.text!.trimmingCharacters(in: .whitespacesAndNewlines), lastName: textFldLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines), dateOfBirth: birthDate, address: lblAddress.text!, phoneNo: textFldMobileNo.text!, boolImageAdded:isImageAdded, image:btnPickPhoto.backgroundImage(for: .normal)!, location: locationCoordinate, city: cityName, state: stateName) { (response) in
            print(response)
            ModalShareInstance.shareInstance.modalUserData = response
            SaveUserResponse.sharedInstance.saveToSharedPrefs(user: response)
            if self.strScreenType == "edit" {
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.performSegue(withIdentifier: "segueAddCard", sender: "Add Card")
            }
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueAddCard" {
//            let objVC : AddCardVC = segue.destination as! AddCardVC
//            objVC.title = (sender as! String)
//        }
//    }
}

extension CreateEditProfileVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        locationCoordinate = place.coordinate
        
        dismiss(animated: true, completion: nil)
        getAddressFromLatLon(pdblLatitude: "\(place.coordinate.latitude)", withLongitude: "\(place.coordinate.longitude)", locationName:place.formattedAddress! )
    }
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String, locationName: String){
        
        APIManager().showHud()
        
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(lat),Double(lon))
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                     self.lblAddress.text = locationName
                self.cityName = address.locality ?? ""
                self.stateName = address.administrativeArea ?? ""
                     APIManager().hideHud()
            }
            
        }
        
    }
    
    
//    func getAddressFromLatLon1(pdblLatitude: String, withLongitude pdblLongitude: String, locationName: String)  {
//
//        APIManager().showHud()
//        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double("\(pdblLatitude)")!
//        //21.228124
//        let lon: Double = Double("\(pdblLongitude)")!
//        //72.833770
//        let ceo: CLGeocoder = CLGeocoder()
//        center.latitude = lat
//        center.longitude = lon
//
//        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//
//        ceo.reverseGeocodeLocation(loc, completionHandler:
//            {(placemarks, error) in
//                if (error != nil)
//                {
//                    print("reverse geodcode fail: \(error!.localizedDescription)")
//                }
//                let pm = placemarks! as [CLPlacemark]
//
//
//
//                if pm.count > 0 {
//                    let pm = placemarks![0]
//                    print(pm.country)
//                    print(pm.locality)
//                    print(pm.subLocality)
//                    print(pm.thoroughfare)
//                    print(pm.postalCode)
//                    print(pm.subThoroughfare)
//
//                    print(pm.addressDictionary as! [String:Any])
//                    APIManager().hideHud()
//
//                    if let stateName = pm.locality{
//
//                        if stateName.contains("San Francisco"){
//                            self.lblAddress.text = locationName
//                        }else{
//                            Progress.instance.displayAlertWindow(userMessage: "We are not working here , please choose from San Franscisco or Bay Area")
//                        }
//                    }
//                }
//                   APIManager().hideHud()
//        })
//        
//    }
    
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

extension CreateEditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
         let image = info[UIImagePickerControllerEditedImage]  as? UIImage ?? info[UIImagePickerControllerOriginalImage] as? UIImage
        
        btnPickPhoto.setBackgroundImage(image, for: .normal)
        isImageAdded = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:-  Open Camera
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            openGallery()
        }
    }
    
    //MARK:-  Open Gallery
    func openGallery() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension CreateEditProfileVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint.zero
        }
    }
}
extension CreateEditProfileVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji" || !((textField.textInputMode?.primaryLanguage) != nil)) {
            return false
        }
       
        
        return true
    }
}
