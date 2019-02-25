
//
//  ViewProfileVC.swift
//  QurahApp
//
//  Created by netset on 7/26/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import FloatRatingView

struct ProfileData {
    var title :String
    var image :UIImage
    var subTitle :String
}

class ViewProfileVC: BaseClass {
    fileprivate var myReviewsList : ModalBase?
    @IBOutlet weak var tblViewProfile: UITableView!
    @IBOutlet weak var btnUserPhoto: UCButton!
    @IBOutlet weak var lblTotalReviews: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    var arrayProfileData : [ProfileData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setupMenuBarButton()
        self.rightBarButton()
        tblViewProfile.estimatedRowHeight = 50
        tblViewProfile.rowHeight = UITableViewAutomaticDimension
        self.getReviewsListAPI(call: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("UpdateRating"), object: nil)
        self.setUpUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UpdateRating"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        let userData = ModalShareInstance.shareInstance.modalUserData.userInfo
         self.lblTotalReviews.text = "(\(userData?.reviewCount ?? 0) Reviews)"
    }
    
    func setUpUserData() {
        let userData = ModalShareInstance.shareInstance.modalUserData.userInfo
        arrayProfileData = [ProfileData(title: "ADDRESS", image:#imageLiteral(resourceName: "location_icon"), subTitle: (userData?.address)!),
                            ProfileData(title: "DATE OF BIRTH", image: #imageLiteral(resourceName: "black_calendar"), subTitle: super.changeBirthDateFormat(strDate:(userData?.dob!)!)),
                                ProfileData(title: "MOBILE NUMBER", image: #imageLiteral(resourceName: "phone"), subTitle: (userData?.phone)!),
                                ProfileData(title: "MY CARDS", image: #imageLiteral(resourceName: "black_calendar"), subTitle: "")]
        
        self.title = (userData?.firstname)! + " " +  (userData?.lastname)!
        if !(userData?.profileImage?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: self.btnUserPhoto.bounds.size.width/2, y: self.btnUserPhoto.bounds.size.height/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            btnUserPhoto.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (userData?.profileImageUrlApi)! as String + (userData?.profileImage)! as String, completionHandler:{(image: UIImage?, url: String) in
                self.btnUserPhoto.setBackgroundImage(image, for: .normal)
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        lblTotalReviews.text = "(\(userData?.reviewCount ?? 0) Reviews)"
        if let rating = userData?.rating {
            ratingView.rating = Double(rating)!
        }
        self.tblViewProfile.reloadData()
    }
    
    func rightBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "edit"), style: .plain, target: self, action: #selector(editAct))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func editAct() {
        self.performSegue(withIdentifier: segueId.editProfile.rawValue, sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId.editProfile.rawValue {
            let objVC : CreateEditProfileVC = segue.destination as! CreateEditProfileVC
            objVC.strScreenType = "edit"
        } else if segue.identifier == segueId.myCards.rawValue {
            let objVC : CardsListVC = segue.destination as! CardsListVC
            objVC.cards = sender as! [Cards]
            objVC.strScreenType = "myCards"
        } else if segue.identifier == segueId.myReviews.rawValue {
            let objVC : ReviewListVC = segue.destination as! ReviewListVC
            objVC.reviews = sender as! ModalBase
        }
    }
    
    @IBAction func tapGestureOnViewReviewsAct(_ sender: Any) {
        if self.myReviewsList == nil  {
            self.getReviewsListAPI(call: true)
        } else {
            if self.myReviewsList?.myReviews?.count == 0 {
                Progress.instance.displayAlert(userMessage: (self.myReviewsList?.message)!)
            } else {
                self.performSegue(withIdentifier: segueId.myReviews.rawValue, sender: self.myReviewsList)
            }
        }
    }
    
    // MARK:- Reviews List API
    func getReviewsListAPI(call:Bool) {
        APIManager.sharedInstance.getReviewListAPI() { (response) in
            self.myReviewsList = response
            self.lblTotalReviews.text = "(\(response.myReviews?.count ?? 0) Reviews)"
            ModalShareInstance.shareInstance.modalUserData.userInfo?.reviewCount = response.myReviews?.count
            SaveUserResponse.sharedInstance.saveToSharedPrefs(user: ModalShareInstance.shareInstance.modalUserData)
        }
    }
}

extension ViewProfileVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProfileData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "viewCardCell") as? CellViewCards else {
                return  CellViewCards()
            }
            cell.selectionStyle = .none
            cell.btnSaveCards.addTarget(self, action: #selector(gotoEditScreen), for: .touchUpInside)
            super.setUpButtonShadow(btn: cell.btnSaveCards)
            cell.configCell(arrayProfileData![indexPath.row])
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CellProfileList else {
            return  CellProfileList()
        }
        cell.selectionStyle = .none
        cell.configCell(arrayProfileData![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            self.goToViewCardScreen()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    @objc func gotoEditScreen() {
        self.goToViewCardScreen()
    }
    
    func goToViewCardScreen() {
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC
//        vc.fromProfile = true
//        self.navigationController?.pushViewController(vc, animated: true)
        
        APIManager.sharedInstance.getCardListAPI() { (response) in
            self.performSegue(withIdentifier: "segueMyCardsVC", sender: response.cards)//
        }
    }
}

class CellProfileList: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    func configCell(_ data : ProfileData) {
        imgView.image = data.image
        lblTitle.text = data.title
        lblSubTitle.text = data.subTitle
    }
}

class CellViewCards: UITableViewCell {
    @IBOutlet weak var btnSaveCards: UIButton!
    func configCell(_ data : ProfileData) {
        // lblSubtitle.layer.cornerRadius = 20.0
        // super.setup
    }
}
