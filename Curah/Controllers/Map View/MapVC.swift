//
//  MapVC.swift
//  Curah
//
//  Created by Netset on 02/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    let zoomLevel: Float = 4.0
    var locManager = CLLocationManager()
    var location = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.mapView
        mapView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let status = CLLocationManager.authorizationStatus()
        if status == .denied { //status == .notDetermined ||
            let alert = UIAlertController(title: "Location Services Disabled", message: "Your currently all location services for this device disabled. Please go to settings to give access." , preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style:.default, handler:{ (action: UIAlertAction!) in
                let url:URL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!)!
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: {
                        (success) in })
                } else {
                    guard UIApplication.shared.openURL(url) else {
                        return
                    }
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        //  mapView.padding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        //  mapView.clear()
        self.getCurrentLocation()
        // self.updateMapView()
    }
    
    /* func updateMapView() {
     // GOOGLE MAPS SDK: BORDER
     //   mapView.padding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 280.0, right: 0.0)
     mapView.isMyLocationEnabled = true
     mapView.clear()
     self.getCurrentPosition()
     }
     
     func getCurrentPosition(){
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let loc =  appDelegate.getLocation()
     self.mapView.camera = GMSCameraPosition.camera(withLatitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude, zoom: zoomLevel)
     } */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}


extension MapVC : CLLocationManagerDelegate{
    
    func getCurrentLocation(){
        self.isAuthorizedtoGetUserLocation()
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.distanceFilter = 10.0
            //locManager.startUpdatingLocation()
        }else{
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
        // locManager.stopUpdatingLocation()
        //   self.getCurrentLocation()
        location = locations.last!
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        locManager.stopUpdatingLocation()
        
        
        let coordinates = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude:location.coordinate.longitude)
        let marker = GMSMarker(position: coordinates)
        marker.map = self.mapView
        marker.appearAnimation = .pop
        marker.icon =  #imageLiteral(resourceName: "map_pin")
        marker.accessibilityLabel = "\(1)"
        self.mapView.reloadInputViews()
        
    }
    
    func getLocation() -> CLLocation {
        return location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
}

// initialize and keep a marker and a custom infowindow
private var tappedMarker = GMSMarker()
private var infoWindow = MarkerInfoWindow()

extension MapVC: GMSMapViewDelegate{
    
    @objc func gotoMaps(sender: UIButton){
        self.openDestinationLocationOnMap()
    }
    
    @objc func viewDetailsBtnAction(sender: UIButton){
        self.performSegue(withIdentifier: "segueDetailMap", sender: nil)
    }
    
    func openDestinationLocationOnMap(){
        let lat = (location.coordinate.latitude+0.722)
        let longi = (location.coordinate.longitude+0.2342)
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let urlString = "http://maps.google.com/?daddr=\(lat),\(longi))&directionsmode=driving"
            UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
        } else {
            let urlString = "http://maps.apple.com/maps?daddr=\(lat),\(longi))&dirflg=d"
            UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
        }
    }
    
    //empty the default infowindow
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let index:Int! = Int(marker.accessibilityLabel!)
        print("markerInfoContents : \(index!)")
        let customInfoWindow = Bundle.main.loadNibNamed("MarkerInfoWindow", owner: self, options: nil)?[0] as! MarkerInfoWindow
        return customInfoWindow
    }

    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    }
    
    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Needed to create the custom info window (this is optional)
    func sizeForOffset(view: UIView) -> CGFloat {
        return 120.0
    }
    
    func sizeForOffsetX(view: UIView) -> CGFloat {
        return -20.0
    }
}

