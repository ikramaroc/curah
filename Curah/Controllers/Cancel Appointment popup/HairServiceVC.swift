//
//  HairServiceVC.swift
//  Curah
//
//  Created by Netset on 18/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import CoreLocation

class HairServiceVC: BaseClass {
    private var locManager = CLLocationManager()
    private var location = CLLocation()
    @IBOutlet weak var lblMainServiceName: UILabel!
    @IBOutlet weak var imgVwMainService: UIImageView!
    var subServicesData : ModalBase!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setupBackBtn(tintClr: .white)
        self.setUpMainImageAndTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpMainImageAndTitle() {
        if !(subServicesData.mainService?.service_photo?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x:imgVwMainService.bounds.size.width/2, y:imgVwMainService.bounds.size.height/2)
            activityView.color = Constants.appColor.appColorMainPurple
            activityView.startAnimating()
            imgVwMainService.addSubview(activityView)
            
           
            self.imgVwMainService.sd_setHighlightedImage(with: URL(string: (subServicesData.imgUrl)! as String + (subServicesData.mainService?.service_photo)! as String), options: .highPriority, completed: { (image, error, cache, url) in
                self.imgVwMainService.image = image!
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
            
            
//            ImageLoader.sharedLoader.imageForUrl(urlString: (subServicesData.imgUrl)! as String + (subServicesData.mainService?.service_photo)! as String, completionHandler:{(image: UIImage?, url: String) in
//                self.imgVwMainService.image = image
//                activityView.stopAnimating()
//                activityView.removeFromSuperview()
//            })
        }
        self.lblMainServiceName.text = subServicesData.mainService?.service_name
    }
}

extension HairServiceVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard subServicesData != nil else {
            return 0
        }
        return subServicesData.services!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SelectServiceCell else {
            return  SelectServiceCell()
        }
        let list = subServicesData.services?[indexPath.row]
        cell.lblTitle.text = list?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //  self.performSegue(withIdentifier: "segueServicesVC", sender: nil)
        boolCallAPI = false
        self.view.endEditing(true)
        selectedIndex = indexPath.row
        if super.locationServicesEnabled() {
            self.getCurrentLocation()
        }
    }
}


fileprivate var selectedIndex : Int = -1
fileprivate var boolCallAPI : Bool = false
extension HairServiceVC : CLLocationManagerDelegate{
    
    func getCurrentLocation(){
        self.isAuthorizedtoGetUserLocation()
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.distanceFilter = 10.0
            locManager.startUpdatingLocation()
        } else {
            print("Location services are not enabled")
        }
    }
    
    //if we have no permission to access user location, then ask user for permission.
    func isAuthorizedtoGetUserLocation() {
        let status = CLLocationManager.authorizationStatus()
        if status != .authorizedWhenInUse{
            locManager.requestWhenInUseAuthorization()
        }
    }
    
    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
            locManager.startUpdatingLocation()
        }
    }
    
    //this method is called by the framework on locationManager.requestLocation();
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        if !boolCallAPI {
            boolCallAPI = true
            self.listOfProvidersAPI(id:(subServicesData.services?[selectedIndex].id)!, name: (subServicesData.services?[selectedIndex].name)!)
        }
        locManager.stopUpdatingLocation()
    }
    
    func getLocation() -> CLLocation {
        return location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    
    //MARK:- Get Provider List API *******
    func listOfProvidersAPI(id:Int,name:String) {
        
//        let objVC : ServicesVC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
//        objVC.title = name
//        objVC.serviceId = id
//        self.navigationController?.pushViewController(objVC, animated: true)
        
        
        APIManager.sharedInstance.getProviderListAPI(serviceId: id, priceRange: Param.lowToHigh.rawValue, page: 0, name: "", enableLoader: true ) { (response) in
            print(response)
            if response.status == 404 {
                Progress.instance.displayAlert(userMessage: "No provider found.")
            } else {
                if (response.provider_list?.count)! > 0 {
                    let objVC : ServicesVC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
                    objVC.title = name
//                    objVC.servicesData = response
                    objVC.serviceId = id
                    self.navigationController?.pushViewController(objVC, animated: true)
                } else {
                    Progress.instance.displayAlert(userMessage: "No provider found.")
                }
            }
        }
    }
}

