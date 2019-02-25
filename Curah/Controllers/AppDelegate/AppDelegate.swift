//
//  AppDelegate.swift
//  QurahApp
//
//  Created by netset on 7/13/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import LGSideMenuController
import GooglePlaces
import GoogleMaps
import FacebookCore
import GoogleSignIn
import AlamofireObjectMapper
import ObjectMapper
import Firebase
import UserNotifications
import Stripe

var latitude: Double = 0.0
var longitude: Double = 0.0
var currentScreenStr: String = ""
var otherUserIdForChat: Int = 0
var bookingIdForNotification : Int = 0
var isFromPaymentScreen  = false
var isSocialLogin = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var locManager = CLLocationManager()
    var location = CLLocation()
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var objSlideMenu = LGSideMenuController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:UIFont(name: Constants.AppFont.fontRoman, size: 20)!]
        //  sleep(2)
        
        //test
        STPPaymentConfiguration.shared().publishableKey = "pk_test_vi5ISB05dUnQLkOPGmseGMHo"
        
        //live
        // STPPaymentConfiguration.shared().publishableKey = "pk_live_PoGYXv2C8mRaMh5QhijNhcW4"
        
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.curah.applePaytest"
        
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // ==================== Google Plus =====================
        //    GMSServices.provideAPIKey("AIzaSyDS55G71rqfd33op6mFmXVUhCFotz36vsY")
        // GMSServices.provideAPIKey("AIzaSyAwfWpyDKwEm8SseZYM2WhRrLOl")
        GMSServices.provideAPIKey("AIzaSyD2MXFJ6yBeFlC6KP0SNRglD0UV6nYyJRY")
        
        
        // GMSPlacesClient.provideAPIKey("AIzaSyDS55G71rqfd33op6mFmXVUhCFotz36vsY")
        GMSPlacesClient.provideAPIKey("AIzaSyD2MXFJ6yBeFlC6KP0SNRglD0UV6nYyJRY")
        
        GIDSignIn.sharedInstance().clientID = "68433816647-3ejno90mmit038hg3bb45ur8oceuc5kh.apps.googleusercontent.com"
        
        
        // ==================== Firebase  =====================
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // ==================== Setup Notifications  =====================
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
        registerForPushNotifications()
        
        UIApplication.shared.applicationIconBadgeNumber = 0

        
        // ==================== Google Plus =====================
        
        self.settingNav()
        if UserDefaults.standard.value(forKey: "USERDETAILS") != nil {
            let responseModel = Mapper<ModalBase>().map(JSONString: UserDefaults.standard.value(forKey: "USERDETAILS") as! String)
            ModalShareInstance.shareInstance.modalUserData = responseModel
            self.makingRoot("enterApp")
        }
        
        // ======================= Enable Location =======================
        self.getCurrentLocation()
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func settingNav() {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(name:Constants.AppFont.fontAvenirHeavy, size:20) as Any, NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CurahApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK:- Facebook Integration
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId = SDKSettings.appId
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" { // facebook
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
        let directedByGGL =  GIDSignIn.sharedInstance().handle(url,
                                                               sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                               annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return  directedByGGL
    }
    
    func makingRoot(_ strRoot: String) {
        self.getCurrentLocation()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if (strRoot == "initial") {
            // self.settingNav()
            let objNav = storyboard.instantiateViewController(withIdentifier: "navigationId") as! UINavigationController
            UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = objNav
            }, completion: { completed in
                // maybe do something here
            })
        } else if strRoot == "enterApp" {
            let objHomeVC = (storyboard.instantiateViewController(withIdentifier: "HomeID") as? HomeViewController)!
            let objNav = UINavigationController(rootViewController: objHomeVC)
            objNav.navigationBar.tintColor = .black
            let objMenuVC: Menu = storyboard.instantiateViewController(withIdentifier: "MenuID") as! Menu
            self.objSlideMenu = LGSideMenuController(rootViewController: objNav, leftViewController: objMenuVC, rightViewController: nil)
            self.objSlideMenu.isLeftViewSwipeGestureEnabled = false
            self.objSlideMenu.leftViewPresentationStyle = .slideBelow
            self.objSlideMenu.leftViewWidth = (self.window?.frame.size.width)!/1.25
            self.window?.rootViewController = self.objSlideMenu
        }
        window?.makeKeyAndVisible()
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: { _ in })
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // on screen refresh
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo =  notification.request.content.userInfo as AnyObject
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        
        let topVC = window?.rootViewController
        let presentedController = topVC as? LGSideMenuController
        if let presentVC:UIViewController  = (presentedController?.rootViewController?.childViewControllers.last) {
            
            if UIApplication.shared.applicationState == .active
            {
                if ((userInfo.value(forKeyPath: "label") as! String) == "Message-Notification") && ((userInfo.value(forKeyPath: "sender_id") as! String) == "\(otherUserIdForChat)" ) && presentVC is ChatVC {
                    NotificationCenter.default.post(name: Notification.Name("RefreshNotification"), object: nil, userInfo: nil)
                    
                }else if ((userInfo.value(forKeyPath: "label") as! String) == "Message-Notification") && presentVC is MessagesListVC  {
                    NotificationCenter.default.post(name: Notification.Name("RefreshNotification"), object: nil, userInfo: nil)
                }
                    
                    
                    
                else if (((userInfo.value(forKeyPath: "label") as! String) == "Start-Service") || ((userInfo.value(forKeyPath: "label") as! String) == "Service-Complete-Notification") || ((userInfo.value(forKeyPath: "label") as! String) == "Reject-Notification") ) &&  presentVC is ServiceDetailsVC && bookingIdForNotification == Int("\(userInfo.value(forKeyPath: "booking_id") as! String)") {
                    NotificationCenter.default.post(name: Notification.Name("RefreshNotification"), object: nil, userInfo: nil)
                }
                else if ((userInfo.value(forKeyPath: "label") as! String) == "Service-Complete-Notification"){
                    var message = String()
                    if  (userInfo.value(forKeyPath: "payment_status") as! String) == "false" {
                        message = "click on yes to see the detail of appointment and proceed payment."
                    }else{
                        message = "click on yes to see the detail of appointment and proceed rating."
                    }
                    
                    
                    Progress.instance.alertMessageWithActionOkCancel(title: "Curah Customer", message: (userInfo.value(forKeyPath: "message") as! String) + "\n" + message) {
                        if let window = UIApplication.shared.delegate?.window
                        {
                            if var viewController = window?.rootViewController
                            {
                                // handle navigation controllers
                                if(viewController is UINavigationController)
                                {
                                    viewController = (viewController as! UINavigationController).visibleViewController!
                                }
                                else if viewController is LGSideMenuController
                                {
                                    let view = viewController as! LGSideMenuController
                                    
                                    var newView = view.rootViewController
                                    
                                    if(newView is UINavigationController)
                                    {
                                        newView = (newView as! UINavigationController).visibleViewController!
                                    }
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    
                                    APIManager.sharedInstance.appointmentDetailAPI(bookingId: Int("\(userInfo.value(forKeyPath: "booking_id") as! String)")!) { (response) in
                                        let newViewController =  storyboard.instantiateViewController(withIdentifier:"ServiceDetailsVC") as! ServiceDetailsVC
                                        newViewController.detail = response
                                        newViewController.bookingId = Int("\(userInfo.value(forKeyPath: "booking_id") as! String)")!
                                        newViewController.fromPushNotification = true
                                        newView?.show(newViewController, sender: self)
                                    }
                                }
                            }
                        }
                    }
                }
                else if (userInfo.value(forKeyPath: "label") as! String) != "Rating-Notification"
                {
                    completionHandler([.alert, .sound])
                }
            }
            else
            {
                completionHandler([.alert, .sound])
            }
            // Print full message.
            print(userInfo)
            
            // Change this to your preferred presentation option
            completionHandler([])
        }
    }
    
    
    // tap action
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo as AnyObject
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        flow(data: userInfo)
        
        completionHandler()
    }
    func flow(data: AnyObject)
    {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let topVC = window?.rootViewController
        let presentedController = topVC as? LGSideMenuController
        if let presentVC:UIViewController  = (presentedController?.rootViewController?.childViewControllers.last) {
            
            if UserDefaults.standard.value(forKey: "USERDETAILS") != nil
            {
                if let window = UIApplication.shared.delegate?.window
                {
                    if var viewController = window?.rootViewController
                    {
                        // handle navigation controllers
                        if(viewController is UINavigationController)
                        {
                            viewController = (viewController as! UINavigationController).visibleViewController!
                        }
                        else if viewController is LGSideMenuController
                        {
                            let view = viewController as! LGSideMenuController
                            
                            var newView = view.rootViewController
                            
                            if(newView is UINavigationController)
                            {
                                newView = (newView as! UINavigationController).visibleViewController!
                            }
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            if (data.value(forKeyPath: "label") as! String) == "Message-Notification"
                            {
                                if ((data.value(forKeyPath: "label") as! String) == "Message-Notification") && ((data.value(forKeyPath: "sender_id") as! String) == "\(otherUserIdForChat)" ) && presentVC is ChatVC {
                                    NotificationCenter.default.post(name: Notification.Name("RefreshNotification"), object: nil, userInfo: nil)
                                }
                                else{
                                    
                                    let newViewController = storyboard.instantiateViewController(withIdentifier:"ChatVC") as! ChatVC
                                    newViewController.connection_id = Int("\(data.value(forKeyPath: "connection_id") as! String)")
                                    newViewController.receiver_id = Int("\(data.value(forKeyPath: "sender_id") as! String)")
                                    newView?.show(newViewController, sender: self)
                                }
                            }
                            else if (data.value(forKeyPath: "label") as! String) == "Accept-Request-Notification" || (data.value(forKeyPath: "label") as! String) == "Start-Service" || (data.value(forKeyPath: "label") as! String) == "Reject-Notification"  || (data.value(forKeyPath: "label") as! String) == "Service-Complete-Notification" //|| (data.value(forKeyPath: "label") as! String) == "Rating-Notification"
                            {
                                if (((data.value(forKeyPath: "label") as! String) == "Start-Service") || ((data.value(forKeyPath: "label") as! String) == "Service-Complete-Notification") || ((data.value(forKeyPath: "label") as! String) == "Reject-Notification") ) &&  presentVC is ServiceDetailsVC && bookingIdForNotification == Int("\(data.value(forKeyPath: "booking_id") as! String)") {
                                    NotificationCenter.default.post(name: Notification.Name("RefreshNotification"), object: nil, userInfo: nil)
                                }else{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        
                                        APIManager.sharedInstance.appointmentDetailAPI(bookingId: Int("\(data.value(forKeyPath: "booking_id") as! String)")!) { (response) in
                                            let newViewController = storyboard.instantiateViewController(withIdentifier:"ServiceDetailsVC") as! ServiceDetailsVC
                                            newViewController.detail = response
                                            newViewController.bookingId = Int("\(data.value(forKeyPath: "booking_id") as! String)")!
                                            newViewController.fromPushNotification = true
                                            newView?.show(newViewController, sender: self)
                                        }
                                    }
                                }
                                
                                
                               
                            }
                            
                            print(newView!)
                        }
                        print(viewController)
                    }
                }
            }
        }
    }
    
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        UserDefaults.standard.setValue(fcmToken, forKey: "device_token")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}


extension AppDelegate : CLLocationManagerDelegate{
    
    func getCurrentLocation(){
        self.isAuthorizedtoGetUserLocation()
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.distanceFilter = 10.0
            locManager.startUpdatingLocation()
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
        location = locations.last!
        self.locManager.stopUpdatingLocation()
    }
    
    func getLocation() -> CLLocation {
        return location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
}
