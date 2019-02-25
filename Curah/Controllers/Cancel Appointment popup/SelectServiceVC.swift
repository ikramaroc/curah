//
//  SelectServiceVC.swift
//  Curah
//
//  Created by Netset on 18/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import CoreLocation

class SelectServiceVC: BaseClass {
    
    @IBOutlet weak var textFldSuggestService: UITextField!
    @IBOutlet weak var lblSelectService: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblMainServiceName: UILabel!
    @IBOutlet weak var imgVwMainService: UIImageView!
    fileprivate var selectedIndex : Int = -1
    var subServicesData : ModalBase!
    var mainServicesData : [Keywords]!
    var filteredData : [Keywords] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.isHidden = false
        self.setupBackBtn(tintClr: .white)
        super.setSearcBar(bar: searchBar, font: UIFont(name: Constants.AppFont.fontRoman, size: 15.0)!)
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
            
            self.imgVwMainService.sd_setHighlightedImage(with: URL(string: (subServicesData.imgUrl)! as String + (subServicesData.mainService?.service_photo)!), options: .highPriority, completed: { (image, error, cache, url) in
                self.imgVwMainService.image = image!
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
            
//            
//            ImageLoader.sharedLoader.imageForUrl(urlString: (subServicesData.imgUrl)! as String + (subServicesData.mainService?.service_photo)! as String, completionHandler:{(image: UIImage?, url: String) in
//                self.imgVwMainService.image = image
//                activityView.stopAnimating()
//                activityView.removeFromSuperview()
//            })
        }
        self.lblMainServiceName.text = subServicesData.mainService?.service_name
    }
    
    @IBAction func btnSubmitAct(_ sender: Any) {
        if (textFldSuggestService.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 {
            self.addSuggestedServiceAPI(name: (textFldSuggestService.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
        } else {
            textFldSuggestService.text = textFldSuggestService.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    //MARK:- Add Suggested Service API *******
    func addSuggestedServiceAPI(name:String) {
        APIManager.sharedInstance.addSuggested_SeviceAPI(name: name) { (response) in
            print(response)
            Progress.instance.displayAlert(userMessage: response.message!)
            self.textFldSuggestService.text = ""
        }
    }
}

extension SelectServiceVC :UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard subServicesData != nil else {
            return 0
        }
        return searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 ? self.filteredData.count : subServicesData.services!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SelectServiceCell else {
            return  SelectServiceCell()
        }
        if searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            cell.lblTitle.text  = filteredData[indexPath.row].name
            return cell
        }
        let list = subServicesData.services?[indexPath.row]
        cell.lblTitle.text = list?.name
        return cell
    }
}


extension SelectServiceVC :UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        selectedIndex = indexPath.row
        if super.locationServicesEnabled() {
           // self.getCurrentLocation()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let loc =  appDelegate.getLocation()
            latitude = loc.coordinate.latitude
            longitude = loc.coordinate.longitude
            if searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                self.listOfProvidersAPI(id:self.filteredData[selectedIndex].id!, name: self.filteredData[selectedIndex].name!)
            } else {
                self.listOfProvidersAPI(id:(subServicesData.services?[selectedIndex].id)!, name: (subServicesData.services?[selectedIndex].name)!)
            }
        }
    }
    
    //MARK:- Get Provider List API *******
    func listOfProvidersAPI(id:Int,name:String) {
        
//        let objVC : ServicesVC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
//        objVC.title = name
//        //                    objVC.servicesData = response
//        objVC.serviceId = id
//        self.navigationController?.pushViewController(objVC, animated: true)
        
        
        APIManager.sharedInstance.getProviderListAPI(serviceId: id, priceRange: Param.lowToHigh.rawValue, page: 0, name: "", enableLoader: true ) { (response) in
            print(response)
            if response.status == 404 {
                Progress.instance.displayAlert(userMessage: "No Data Found")
            } else {
                if (response.provider_list?.count)! > 0 {
                    let objVC : ServicesVC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
                    objVC.title = name
//                    objVC.servicesData = response
                    objVC.serviceId = id
                    self.navigationController?.pushViewController(objVC, animated: true)
                } else {
                    Progress.instance.displayAlert(userMessage: "No Data Found")
                }
            }
        }
    }
}

extension SelectServiceVC : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton=false
        self.view.endEditing(true)
        self.filteredData.removeAll()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText.trimmingCharacters(in: .whitespacesAndNewlines))
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            self.filteredData = (mainServicesData?.filter {$0.name?.range(of: searchText.trimmingCharacters(in: .whitespacesAndNewlines), options: [.anchored, .caseInsensitive, .diacriticInsensitive]) != nil })!
            print(self.filteredData)
            self.tableView.reloadData()
        }
    }
}


class SelectServiceCell: UITableViewCell {
    @IBOutlet weak var lblTitle :UILabel!
}
