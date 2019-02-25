//
//  HomeViewController.swift
//  QurahApp
//
//  Created by netset on 7/16/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class HomeViewController: BaseClass {
    //MARK:-  OUTLET(S) 
    private var locManager = CLLocationManager()
    private var location = CLLocation()
    @IBOutlet weak var homeTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK:-  CONSTANT(S) 
    var allServices : ModalBase!
    var isSearchON : Bool = false
    var filteredData : [Keywords] = []
    let services = [segueId.subServices.rawValue,segueId.subServices.rawValue,segueId.subServices.rawValue,segueId.subServicesOthers.rawValue]
    //MARK:-  LIFE CYCLE(S) 
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setupMenuBarButton()
        rightBarButton()
        self.title = "Home"
        super.setSearcBar(bar: searchBar, font: UIFont(name: Constants.AppFont.fontRoman, size: 15.0)!)
        self.getMainServicesAPI()
        
    }
    
    func rightBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "provider_tools"), style: .plain, target: self, action: #selector(editAct))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func editAct() {
        
        APIManager.sharedInstance.getProviderListAPI(serviceId: 0, priceRange: Param.lowToHigh.rawValue, page: 0, name: "", enableLoader: true ) { (response) in
                print(response)
                if response.status == 404 {
                    Progress.instance.displayAlert(userMessage: response.message ?? "No data found")
                } else if response.status == 200 {
                    let objVC : ServicesVC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
                    objVC.title = "Service Providers"
                    objVC.serviceId = 0
                    self.navigationController?.pushViewController(objVC, animated: true)
                }
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK:- Get Servies API *******
    
    func getMainServicesAPI() {
        APIManager.sharedInstance.getMainSevicesAPI() { (response) in
            print(response)
            self.allServices = response
            self.homeTable.reloadData()
        }
    }
    
    func getServicesAPI(index:Int) {
        APIManager.sharedInstance.getSevicesAPI(mainServiceId:(allServices.mainServices?[index].id)!) { (response) in
            print(response)
            self.performSegue(withIdentifier: self.services[index], sender: response)
            /*self.allServices = response
             self.homeTable.reloadData()*/
        }
    }
    
    
    //MARK:- Get Provider List API *******
    func listOfProvidersAPI() {
        APIManager.sharedInstance.getProviderListAPI(serviceId: filteredData[selectedIndex].id!, priceRange: Param.lowToHigh.rawValue, page: 0, name: "", enableLoader: true ) { (response) in
            print(response)
            if response.status == 404 {
                Progress.instance.displayAlert(userMessage: response.message ?? "No data found")
            } else {
                if (response.provider_list?.count)! > 0 {
                    let objVC : ServicesVC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
                    objVC.title = self.filteredData[selectedIndex].name
                    objVC.servicesData = response
                    objVC.serviceId = self.filteredData[selectedIndex].id!
                    self.navigationController?.pushViewController(objVC, animated: true)
                } else {
                    Progress.instance.displayAlert(userMessage: response.message ?? "No data found")
                }
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.subServices.rawValue {
            let objVC : HairServiceVC = segue.destination as! HairServiceVC
            objVC.subServicesData = sender as! ModalBase
        } else if segue.identifier == segueId.subServicesOthers.rawValue {
            let objVC : SelectServiceVC = segue.destination as! SelectServiceVC
            objVC.subServicesData = sender as! ModalBase
            objVC.mainServicesData = allServices.keywordsWords
        }
    }
}

//MARK:-  TABLE DATA SOURCE DELEGATES(S) 
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard allServices?.mainServices != nil else {
            return 0
        }
        if isSearchON {
            return filteredData.count
        }
        return (allServices.mainServices?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        if !isSearchON {
            let cell = homeTable.dequeueReusableCell(withIdentifier: "HomeTableCell") as! HomeTableCell
            cell.categoryTitle.text = allServices.mainServices?[indexPath.row].service_name
            if !(allServices.mainServices?[indexPath.row].service_photo?.isEmpty)!{
                let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                activityView.center = CGPoint(x:cell.categoryImage.bounds.size.width/2, y:cell.categoryImage.bounds.size.height/2)
                activityView.color = Constants.appColor.appColorMainPurple
                activityView.startAnimating()
                cell.categoryImage.addSubview(activityView)
                
                cell.categoryImage.image = nil
                cell.categoryImage.sd_setHighlightedImage(with: URL(string: (allServices.imgUrl)! as String + (allServices.mainServices?[indexPath.row].service_photo)!), options: .highPriority, completed: { (image, error, cache, url) in
                    cell.categoryImage.image = image!
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                })
            }
            return cell
        }
        let cell = homeTable.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.font = UIFont(name: Constants.AppFont.fontAvenirRoman, size: 14.0)
        cell?.textLabel?.text = filteredData[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchON {
            selectedIndex = indexPath.row
            boolCallAPI = false
            if super.locationServicesEnabled() {
                self.getCurrentLocation()
            }
        } else {
            self.getServicesAPI(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isSearchON {
            return CGFloat(Int(self.view.frame.size.height-106)/(allServices.mainServices?.count)!)
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension HomeViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchON = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchON = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            isSearchON = false
        } else {
            isSearchON = true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard allServices?.mainServices != nil else {
            return
        }
        print(searchText.trimmingCharacters(in: .whitespacesAndNewlines))
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            self.filteredData = (allServices.keywordsWords?.filter {$0.name?.range(of: searchText.trimmingCharacters(in: .whitespacesAndNewlines), options: [.anchored, .caseInsensitive, .diacriticInsensitive]) != nil })!
            print(self.filteredData)
        }
    }
}

fileprivate var selectedIndex : Int = -1
fileprivate var boolCallAPI : Bool = false
extension HomeViewController : CLLocationManagerDelegate{
    
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
            self.listOfProvidersAPI()
        }
        locManager.stopUpdatingLocation()
    }
    
    func getLocation() -> CLLocation {
        return location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
}
