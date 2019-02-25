//
//  ServicesVC.swift
//  Curah
//
//  Created by Netset on 18/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import FloatRatingView
import GoogleMaps
import CoreLocation
import SDWebImage

class ServicesVC: BaseClass {
    var servicesData : ModalBase!
    var servicesPaginationData : ModalBase!
    var serviceId : Int!
    
    @IBOutlet weak var mainViewRound: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnShowMap: UIButton!
    @IBOutlet weak var btnShowTable: UIButton!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var boolCallAPI : Bool = false
    
    //MARK:- **** MapView Work
    @IBOutlet weak var mapView: GMSMapView!
    let zoomLevel: Float = 12.0
    private var location = CLLocation()
    var loading = Bool()
    private var lastContentOffset: CGFloat = 0
    var enableLoading = Bool()
    var pageNumber = Int()
    var scrollDirection = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageNumber = 0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 115
        tableView.tableFooterView = UIView()
        super.setupBackBtn(tintClr: .white)
        super.setSearcBar(bar: searchBar, font: UIFont(name: Constants.AppFont.fontRoman, size: 15.0)!)
        super.setUpViewShadow(vw: mainViewRound)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (self.servicesData != nil){
            self.servicesData.provider_list?.removeAll()
        }
        
        
        if (self.servicesPaginationData != nil){
            self.servicesPaginationData.provider_list?.removeAll()
        }
        
        getServiceData(page: 0, loaderEnable: true)
        
        boolCallAPI = false
         self.updateMapAndTable()
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.myLocationButton = true
        
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: AppDelegate().getLocation().coordinate.latitude, longitude: AppDelegate().getLocation().coordinate.longitude, zoom: zoomLevel)
        self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude: AppDelegate().getLocation().coordinate.latitude, longitude: AppDelegate().getLocation().coordinate.longitude))
        
        guard servicesData != nil else {
            return
        }

        
      
    }
 
    
    func getServiceData(page:Int,loaderEnable:Bool){
        APIManager.sharedInstance.getProviderListAPI(serviceId: serviceId, priceRange: Param.lowToHigh.rawValue, page: page, name: "", enableLoader: loaderEnable ) { (response) in
            print(response)
                self.tableView.tableFooterView?.isHidden = true
            if response.status == 404 {
                Progress.instance.displayAlert(userMessage:response.message ?? "No data found")
            } else {

                var dataForPagination: ModalBase!
                
                if (response.provider_list?.count)! > 0 {
                    
                    self.servicesData = response
                    self.servicesData.provider_list?.removeAll()
                    
                    if self.servicesPaginationData != nil{
                        if (self.servicesPaginationData.provider_list?.count)! > 0{
                            for providers in (self.servicesPaginationData.provider_list)!{
                                self.servicesData.provider_list?.append(providers)
                            }
                        }
                        self.servicesPaginationData.provider_list?.removeAll()

                    }
                    
                    for providers in (response.provider_list)!{
                        self.servicesData.provider_list?.append(providers)
                    }
                    
                    self.servicesPaginationData = self.servicesData
                    self.tableView.reloadData()
                    
                    self.updateMapAndTable()
                } else {
                    Progress.instance.displayAlert(userMessage: response.message ?? "No data found")
                }
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnShowTable(_ sender: UIButton) {
        self.mapView.isHidden = true
        self.tableView.isHidden = false
        sender.backgroundColor = Constants.appColor.appColorMainGreen
        sender.tintColor = .white
        self.btnShowMap.backgroundColor = .white
        self.btnShowMap.tintColor = .black
    }
    
    @IBAction func btnShowMap(_ sender: UIButton) {
        self.mapView.isHidden = false
        self.tableView.isHidden = true
        sender.backgroundColor = Constants.appColor.appColorMainGreen
        self.btnShowTable.backgroundColor = .white
        sender.tintColor = .white
        self.btnShowTable.tintColor = .black
    }
    
    @objc func chatVC(sender:UIButton){
        
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        let list = servicesData?.provider_list?[sender.tag]
        newViewController.connection_id = list?.connectionId ?? 0
        newViewController.receiver_id = list?.id
        
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
    @objc func goToProfile(sender:UIButton){
        let list = servicesData?.provider_list?[sender.tag]
        
        APIManager.sharedInstance.viewOtherUserProfile(providerId: (list?.id)!) { (response) in
            print(response)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileID") as! ProfileVC
            vc.profileData = response
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func btnFilters(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FiltersVC") as? FiltersVC {
            vc.objProtocol = self
            present(vc, animated: true, completion: nil)
        }
    }
}

extension ServicesVC :UIScrollViewDelegate{  // MARK: - Scrollview Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            scrollDirection = "up"
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            scrollDirection = "down"
        }
        
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    
    // MARK: - Scrollview Delegate used for pagination
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !loading {
            
            if scrollDirection == "up"
            {
                let endScrolling: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height
                //                if jobData.count > 10 || jobData.count == 10
                //                {
                if (endScrolling >= scrollView.contentSize.height) && (servicesData.provider_list!.count < servicesData.totalCount! )
                {
                    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                    self.tableView.tableFooterView = spinner
                    self.tableView.tableFooterView?.isHidden = false
                    perform(#selector(self.loadDataDelayed), with: nil, afterDelay: 1)
                }
                //                }
            }
        }
    }
    // MARK: - Pagination action
    @objc func loadDataDelayed()
    {
        enableLoading = true
        tableView.tableFooterView?.isHidden = false
        pageNumber = pageNumber + 1
        getServiceData(page: pageNumber, loaderEnable: false)
        
    }
}
extension ServicesVC :UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard servicesData != nil else {
            return 0
        }
        return (servicesData.provider_list?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ServiceCell else {
            return  ServiceCell()
        }
        let list = servicesData?.provider_list?[indexPath.row]
        if !(list?.profileImg?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: cell.imgView.bounds.size.width/2, y: cell.imgView.bounds.size.height/2)
            activityView.color = Constants.appColor.appColorMainPurple
            activityView.startAnimating()
            cell.imgView.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (servicesData.imgUrl)! + (servicesData?.provider_list?[indexPath.row].profileImg)! as String, completionHandler:{(image: UIImage?, url: String) in
                cell.imgView.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        cell.btnChat.addTarget(self, action: #selector(chatVC(sender:)), for: .touchUpInside)
        
        cell.btnChat.tag = indexPath.row
        cell.lblName.text = (list?.firstname)! + " " + (list?.lastname)!
        cell.lblDistance.text = "(\(list?.distance ?? 0) miles away)"
        cell.lblPrice.text = "$\(list?.price ?? 0)"
        if let rating = list?.user_rating {
            cell.ratingView.rating = Double(rating)!
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = servicesData?.provider_list?[indexPath.row]
        APIManager.sharedInstance.viewOtherUserProfile(providerId: (list?.id)!) { (response) in
            print(response)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileID") as! ProfileVC
            vc.profileData = response
            vc.serviceId = self.serviceId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ServicesVC : CallbackOnProviderListingScreen {
    func callProviderListingAPI(priceRange:String, paginationIndex:Int ) {
        self.view.endEditing(true)
        APIManager.sharedInstance.getProviderListAPI(serviceId:serviceId, priceRange: priceRange, page: paginationIndex, name: searchBar.text!, enableLoader: true ) { (response) in
            print(response)
            if response.status == 404 {
                if paginationIndex == 0 {
                    self.servicesData = nil
                    self.reloadWhileEmpty()
                    Progress.instance.displayAlert(userMessage: response.message ?? "No data found")
                }
            } else {
                if (response.provider_list?.count)! > 0 {
                    self.servicesData = response
                    self.reloadWhileEmpty()
                } else {
                    Progress.instance.displayAlert(userMessage: response.message ?? "No data found")
                }
            }
        }
    }
    
    func reloadWhileEmpty()  {
      //  self.mapView.clear()
        self.tableView.reloadData()
        self.updateMapAndTable()
    }
    
    func updateMapAndTable() {
       // self.mapView.clear()
        self.tableView.reloadData()
        guard servicesData != nil else {
            return
        }
        let count : Int = (servicesData.provider_list?.count)!
        for i in 0..<count {
            let list = servicesData?.provider_list?[i]
            var lati = 0.0
            var longi = 0.0
            if let lat = list?.latitude {
                lati = Double(lat)!
            }
            if let long = list?.longitude {
                longi = Double(long)!
            }
            
            let markerView = UIView(frame:(CGRect(x: 0, y: 0, width: 30, height: 30)))
            markerView.backgroundColor = UIColor.clear
            
            let imageView1 = UIImageView(frame:(CGRect(x: 0, y: 0, width: 30, height: 30)))
            imageView1.image = #imageLiteral(resourceName: "map_pin")
            
            let imageUrl:String =  servicesData.imgUrl! +  (list?.profileImg!)!
            
            let imageView2 = UIImageView(frame:(CGRect(x: 2, y: 2, width: 24, height: 24)))
            imageView2.roundCornerWithWhiteBorder()
            imageView2.clipsToBounds = true
            if imageUrl.count != 0
            {
                
                imageView2.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "map_pin"), options: SDWebImageOptions.highPriority, completed: { (image, error, cacheType, imageUrl) in
                    imageView2.roundCornerWithWhiteBorder()
                })
            }
            else
            {
                imageView2.image = #imageLiteral(resourceName: "map_pin")
            }
            
            markerView.addSubview(imageView1)
            markerView.addSubview(imageView2)
            markerView.bringSubview(toFront: imageView2)
            
            let renderer = UIGraphicsImageRenderer(size: markerView.bounds.size)
            let imageFinal = renderer.image { ctx in
                markerView.drawHierarchy(in: markerView.bounds, afterScreenUpdates: true)
            }
            
            
            let coordinates = CLLocationCoordinate2D(latitude:lati, longitude:longi)
            let marker = GMSMarker(position: coordinates)
            marker.map = self.mapView
            marker.appearAnimation = .pop
            marker.iconView = markerView
            //            marker.icon = imageFinal
            marker.accessibilityLabel = "\(i)"
            
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: lati, longitude: longi, zoom: zoomLevel)
            self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude: lati, longitude: longi))
            
            marker.userData = i + 100
        }
        infoWindow.removeFromSuperview()
        //        self.mapView.reloadInputViews()
    }
}

extension ServicesVC : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.callProviderListingAPI(priceRange: Param.lowToHigh.rawValue, paginationIndex: 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.callProviderListingAPI(priceRange: Param.lowToHigh.rawValue, paginationIndex: 0)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

// initialize and keep a marker and a custom infowindow
private var tappedMarker = GMSMarker()
private var infoWindow = MarkerInfoWindow()

extension ServicesVC: GMSMapViewDelegate {
    
    @objc func gotoMaps(sender: UIButton) {
        self.openDestinationLocationOnMap()
    }
    
    @objc func viewDetailsBtnAction(sender: UIButton) {
        //  self.performSegue(withIdentifier: "segueDetailMap", sender: nil)
        let index = tappedMarker.accessibilityLabel
        print(index!)
        // "API FIRE TO GET PROVIDER DETAIL"  self.getDetailAPI(id: (venueList[Int(index!)!].venue?.id)!, screenType: "")
    }
    
    
    
    func openDestinationLocationOnMap() {
        let index = tappedMarker.accessibilityLabel
        let list = servicesData?.provider_list?[Int(index!)!]
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let urlString = "http://maps.google.com/?daddr=\(list?.latitude ?? "0"),\(list?.longitude ?? "0"))&directionsmode=driving"
            UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
        } else {
            let urlString = "http://maps.apple.com/maps?daddr=\(list?.latitude ?? "0"),\(list?.longitude ?? "0"))&dirflg=d"
            UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
        }
    }
    
    // reset custom infowindow whenever marker is tapped
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let index:Int! = Int(marker.accessibilityLabel!)
        print("markerInfoContents : \(index!)")
        let list = servicesData?.provider_list?[Int(index!)]
        tappedMarker = marker
        infoWindow.removeFromSuperview()
        infoWindow = Bundle.main.loadNibNamed("MarkerInfoWindow", owner: self, options: nil)?[0] as! MarkerInfoWindow
        if UIDevice.current.userInterfaceIdiom != .phone {
            infoWindow.frame = CGRect(x: 0, y: 0, width: infoWindow.frame.size.width+80, height: infoWindow.frame.size.height+30)
        }
        var lati = 0.0
        var longi = 0.0
        if let lat = list?.latitude {
            lati = Double(lat)!
        }
        if let long = list?.longitude {
            longi = Double(long)!
        }
        let coordinates = CLLocationCoordinate2D(latitude:lati, longitude:longi)
        infoWindow.center = mapView.projection.point(for: coordinates)
        infoWindow.lblName.text = (list?.firstname)! + " " + (list?.lastname)!
        infoWindow.lblDistance.text = "(\(list?.distance ?? 0) miles away)"
        infoWindow.lblPrice.text = "$\(list?.price ?? 0)"
        if let rating = list?.user_rating {
            infoWindow.lblRatingVw.rating = Double(rating)!
        }
        infoWindow.btnChat.addTarget(self, action: #selector(chatVC(sender:)), for: .touchUpInside)
        infoWindow.btnChat.tag = index
        
        infoWindow.userNameBtn.addTarget(self, action: #selector(goToProfile(sender:)), for: .touchUpInside)
        infoWindow.userNameBtn.tag = index
        
        infoWindow.center.x = infoWindow.center.x - sizeForOffsetX(view: infoWindow)
        infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow)
        infoWindow.backgroundColor = .clear
        self.mapView.addSubview(infoWindow)
        return false
    }
    
    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let index = tappedMarker.accessibilityLabel
        guard servicesData != nil else {
            return
        }
        if index != nil {
            if Int(index!)! >= (servicesData.provider_list?.count)! {
                print("something went wrong")
            } else {
                let list = servicesData?.provider_list?[Int(index!)!]
                var lati = 0.0
                var longi = 0.0
                if let lat = list?.latitude {
                    lati = Double(lat)!
                }
                if let long = list?.longitude {
                    longi = Double(long)!
                }
                let coordinates = CLLocationCoordinate2D(latitude:lati, longitude:longi)
                infoWindow.center = mapView.projection.point(for: coordinates)
                infoWindow.center.x = infoWindow.center.x - sizeForOffsetX(view: infoWindow)
                infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow)
                
            }
        }
        //infoWindow.removeFromSuperview()
    }
    
    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
        mapView.reloadInputViews()
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        // let vc = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        // navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Needed to create the custom info window (this is optional)
    func sizeForOffset(view: UIView) -> CGFloat {
        return 120.0
    }
    
    func sizeForOffsetX(view: UIView) -> CGFloat {
        return -20.0
    }
}

class ServiceCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
