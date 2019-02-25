//
//  Menu.swift
//  Curah
//
//  Created by Netset on 18/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import LGSideMenuController

struct SideMenu {
    var title :String
    var image :UIImage
}

class Menu: BaseClass {
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var arraySideMenu = [SideMenu(title: "Home", image: #imageLiteral(resourceName: "home")),SideMenu(title: "My Profile", image:#imageLiteral(resourceName: "user")),SideMenu(title: "History", image: #imageLiteral(resourceName: "history")),SideMenu(title: "Appointment", image: #imageLiteral(resourceName: "appointment")),SideMenu(title: "Favorites", image: #imageLiteral(resourceName: "favourites")),SideMenu(title: "Messages", image: #imageLiteral(resourceName: "message")),SideMenu(title: "Notifications", image: #imageLiteral(resourceName: "notification")),SideMenu(title: "Settings", image: #imageLiteral(resourceName: "setting"))]
    let storyboardIds = ["HomeID", "ViewProfileID", "HistoryListID", "MyAppointmentID", "FavoritesListID", "MessagesListID", "NotificationListID", "SettingsID"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        initView()
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToProfileTapGestureAction(_ sender: UITapGestureRecognizer) {
        let objLGSideMenu: LGSideMenuController? = (parent as? LGSideMenuController)
        let objVC = storyboard?.instantiateViewController(withIdentifier: "ViewProfileID")
        let objNav = UINavigationController(rootViewController: objVC!)
        objNav.navigationBar.tintColor = .black
        objLGSideMenu?.rootViewController = objNav
        objLGSideMenu?.hideLeftView(animated:true, completionHandler:nil)
    }
    
    
    @IBAction func btnLogoutAct(_ sender: Any) {
        let actionSheetController = UIAlertController (title: "Are you sure you want to logout ?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        //Add Cancel-Action
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        //Add Save-Action
        actionSheetController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
            UserDefaults.standard.removeObject(forKey: "USERDETAILS")
            UserDefaults.standard.synchronize()
            ModalShareInstance.shareInstance.modalUserData = nil
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.makingRoot("initial")
        }))
        //present actionSheetController
        present(actionSheetController, animated:true, completion:nil)
    }
    
    func initView() {
        super.setUpButtonShadow(btn: btnLogout, .black, 18.0)
        imgViewProfile.layer.borderWidth = 1
        imgViewProfile.layer.borderColor = UIColor.white.cgColor
        let userData = ModalShareInstance.shareInstance.modalUserData.userInfo
        lblName.text = (userData?.firstname)! + " " +  (userData?.lastname)!
        lblAddress.text = (userData?.address)!
        
        if !(userData?.profileImage?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: imgViewProfile.bounds.size.width/2, y: imgViewProfile.bounds.size.height/2)
            activityView.color = Constants.appColor.appColorMainPurple
            activityView.startAnimating()
            imgViewProfile.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (userData?.profileImageUrlApi)! as String + (userData?.profileImage)! as String, completionHandler:{(image: UIImage?, url: String) in
                self.imgViewProfile.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
    }
}

extension Menu :UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySideMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SideMenuCell else {
            return  SideMenuCell()
        }
        cell.configCell(arraySideMenu[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension Menu :UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objLGSideMenu: LGSideMenuController? = (parent as? LGSideMenuController)
        let objVC = storyboard?.instantiateViewController(withIdentifier: storyboardIds[indexPath.row])
        let objNav = UINavigationController(rootViewController: objVC!)
        objNav.navigationBar.tintColor = .black
        objLGSideMenu?.rootViewController = objNav
        objLGSideMenu?.hideLeftView(animated:true, completionHandler:nil)
    }
}

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    
    func configCell(_ data : SideMenu) {
        imgView.image = data.image
        lblTitle.text = data.title
    }
}
