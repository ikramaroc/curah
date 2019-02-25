//
//  Progress.swift
//  United Cabs
//
//  Created by Apple on 27/04/18.
//  Created by United Cabs. All rights reserved.
//

import UIKit
import MBProgressHUD
class Progress: NSObject {
    static let instance = Progress()
    var hud = MBProgressHUD()
    var window: UIWindow?
    
    override init() {
        window = UIApplication.shared.keyWindow
    }
    
    func show() {
        hud = MBProgressHUD.showAdded(to: window!, animated: true)
        hud.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        hud.mode = .indeterminate
    }
    
    func hide() {
        hud.hide(animated: true)
    }
    
    func displayAlert( userMessage: String,  completion: (() -> ())? = nil) {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        let alertView = UIAlertController(title: Constants.App.name, message: userMessage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            if completion != nil {
                completion!()
            }
        }))
        topVC?.present(alertView, animated: true, completion: nil)
    }
    
    func displayAlertWindow( userMessage: String,  completion: (() -> ())? = nil) {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        let alertView = UIAlertController(title: Constants.App.name, message: userMessage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            if completion != nil {
                completion!()
            }
        }))
        window!.rootViewController!.present(alertView, animated: true, completion: nil)
    }
    
    func alertMessageWithActionOkCancel(title: String, message: String,action:@escaping ()->())
    {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Yes", style: .default) {  (result : UIAlertAction) -> Void in
            print("You pressed ok")
            
            action()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) {  (result : UIAlertAction) -> Void in
            print("You pressed cancel")
            
            topVC?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
         topVC?.present(alert, animated: true, completion: nil)
    }
    
    func alertMessageWithActionOk(title: String, message: String,action:@escaping ()->())
    {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) {  (result : UIAlertAction) -> Void in
            print("You pressed ok")
            
            action()
        }
        alert.addAction(action)
        
        topVC?.present(alert, animated: true, completion: nil)
    }
    
    func alertMessageOkWithBack(title: String, message: String, viewcontroller:UIViewController) {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        
        let alert = UIAlertController(title: Constants.App.name, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "OK", style: .default) {  (result : UIAlertAction) -> Void in
            print("You pressed OK")
            
            viewcontroller.navigationController?.popViewController(animated: true)
            
        }
        
        alert.addAction(action)
         topVC?.present(alert, animated: true, completion: nil)
    }
    
}
