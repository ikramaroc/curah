//
//  ProfileVC.swift
//  CurahApp
//
//  Created by Netset on 28/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import FloatRatingView
import AVKit
import SKPhotoBrowser

class ProfileVC: BaseClass {
    let tabs = [
        ViewPagerTab(title: "List of Services", image: nil),
        ViewPagerTab(title: "Book Appointment", image: nil),
        ]
    
    @IBOutlet var viewSwipeHeightConst: NSLayoutConstraint!
    @IBOutlet weak var collectionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var ratingVw: FloatRatingView!
    @IBOutlet weak var lblReviewsCount: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    fileprivate let btnFavo = UIButton()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintHeightSwipeView: NSLayoutConstraint!
    @IBOutlet weak var viewSwipe: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var labelPhotosVideos: UILabel!
    fileprivate var images = [SKPhoto]()
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    var profileData : ModalBase!
    var serviceId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSwipeView()
        super.setupBackBtn(tintClr: .white)
        self.setFavoBtn()
        self.setUpData()
    }
    
    func setUpData() {
        let userData = profileData.providerInfo
        self.title = (userData?.firstname)! + " " + (userData?.lastname)!
        if !(userData?.profileImage?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: self.imgViewProfile.bounds.size.width/2, y: self.imgViewProfile.bounds.size.height/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            self.imgViewProfile.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (profileData.portfolio_url)! as String + (userData?.profileImage)! as String, completionHandler:{(image: UIImage?, url: String) in
                self.imgViewProfile.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        if let rating = userData?.rating {
            ratingVw.rating = Double(rating)!
        }
        self.lblDistance.text = "(\(userData?.distance ?? 0) miles away)"
        self.lblReviewsCount.text = "(\(userData?.reviewCount ?? 0) Reviews)"
        self.lblLocation.text = userData?.address
        self.lblExperience.text = userData?.experience
        self.btnFavo.isSelected = (userData?.likeStatus == "true") ? true : false
        if profileData.providerPortfolio?.count == 0 {
            self.labelPhotosVideos.text = ""
            self.collectionHeightConst.constant = 0
        }
        if (profileData.providerPortfolio?.count)! > 0 {
            let count : Int = (profileData.providerPortfolio?.count)!
            for item in 0..<count {
                if profileData.providerPortfolio?[item].type == "I" {
                    let photo = SKPhoto.photoWithImageURL((profileData.portfolio_url)! as String + (profileData.providerPortfolio?[item].file)!.replacingOccurrences(of: " ", with: "%20"))
                    photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
                    images.append(photo)
                }
            }
        }
    }
    
    func setFavoBtn() {
        btnFavo.setImage(#imageLiteral(resourceName: "round_heart"), for: .normal)
        btnFavo.setImage(#imageLiteral(resourceName: "sel_round_heart"), for: .selected)
        btnFavo.addTarget(self, action: #selector(btnFavoAct), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnFavo)
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @IBAction func viewReviewsAction(_ sender: UITapGestureRecognizer) {
        self.getReviewsListAPI()
        
    }
    
    @IBAction func facebookBtnAction(_ sender: UIButton) {
        
        if profileData.providerInfo?.facebookLink?.count != 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.facebookLinkNotAvailable)
        } else {
        
        if (profileData.providerInfo?.facebookLink?.validateUrl())!{
            let finalUrl = setUrl(str: (profileData.providerInfo?.facebookLink!)!)
            if let url = URL(string: finalUrl) {
                if #available(iOS 10, *){
                    UIApplication.shared.open(url)
                }else{
                    UIApplication.shared.openURL(url)
                }
            }
        }else{
            Progress.instance.displayAlert(userMessage: Validation.call.facebookLinkNotAvailable)
        }
        }
        
    }
    
    func setUrl(str:String) -> String{
        if str.contains("http") || str.contains("https"){
            return str
        }else{
            return "http://" + str
        }
    }
    
    @IBAction func instagramBtnAction(_ sender: UIButton) {
        
        if profileData.providerInfo?.instagramLink?.count != 0 {
            Progress.instance.displayAlert(userMessage: Validation.call.instagramLinkNotAvailable)
        } else {
        
        if (profileData.providerInfo?.instagramLink?.validateUrl())!{
            
            let finalUrl = setUrl(str: (profileData.providerInfo?.instagramLink!)!)
            
            if let url = URL(string: finalUrl) {
                if #available(iOS 10, *){
                    UIApplication.shared.open(url)
                }else{
                    UIApplication.shared.openURL(url)
                }
            }
        }else{
            Progress.instance.displayAlert(userMessage: Validation.call.instagramLinkNotAvailable)
        }
        }
        
    }
    
    // MARK:- Reviews List API
    func getReviewsListAPI() {
        APIManager.sharedInstance.getOtherUserReviewListAPI(otherUserId:(profileData.providerInfo?.id!)!) { (response) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewListVC") as! ReviewListVC
            vc.reviews = response
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    @objc func btnFavoAct(sender:UIButton) {
        if sender.isSelected {
            self.removeFavoAPI(id: (profileData.providerInfo?.id)!)
        } else {
            self.addFavoAPI(id: (profileData.providerInfo?.id)!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.height / 2
    }
    
    @IBAction func btnChatAct(_ sender: Any) {
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        newViewController.connection_id = profileData.connection_id ?? 0
        newViewController.receiver_id = profileData.providerInfo?.id!
        
        self.navigationController?.pushViewController(newViewController, animated: true)
        // self.performSegue(withIdentifier: "segueChatVC", sender: nil)
    }
    
    func setSwipeView(){
        //self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        DispatchQueue.main.async {
            self.options = ViewPagerOptions(viewPagerWithFrame: self.viewSwipe.bounds)
            self.options.tabType = ViewPagerTabType.basic
            self.options.tabViewImageSize = CGSize(width: 20, height: 20)
            self.options.tabViewTextFont = UIFont(name: Constants.AppFont.fontAvenirMedium, size: 16)!
            self.options.tabViewPaddingLeft = 30
            self.options.tabViewPaddingRight = 30
            self.options.isTabHighlightAvailable = true
            self.options.tabViewHeight = 40
            self.options.tabIndicatorViewHeight = 2
            self.options.tabIndicatorViewBackgroundColor  = Constants.appColor.appColorMainGreen
            self.options.tabViewBackgroundDefaultColor = UIColor(red: 203/255.0, green: 161/255.0, blue: 182/255.0, alpha: 1.0)
            self.options.tabViewBackgroundHighlightColor = UIColor(red: 203/255.0, green: 161/255.0, blue: 182/255.0, alpha: 1.0)
            self.viewPager = ViewPagerController()
            self.viewPager.options = self.options
            self.viewPager.dataSource = self
            self.viewPager.delegate = self
            self.addChildViewController(self.viewPager)
            self.viewSwipe.addSubview(self.viewPager.view)
            self.viewPager.didMove(toParentViewController: self)
        }
    }
    
    
    func addFavoAPI(id:Int) {
        // lowToHigh == Like
        APIManager.sharedInstance.addOrDeleteFavoAPI(type: Param.lowToHigh.rawValue, providerId: id, response: { (response) in
            self.btnFavo.isSelected = true
        })
    }
    
    func removeFavoAPI(id:Int) {
        APIManager.sharedInstance.addOrDeleteFavoAPI(type: Param.unlike.rawValue, providerId: id, response: { (response) in
            print(response)
            self.btnFavo.isSelected = false
        })
    }
}

extension ProfileVC: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        if position == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListOfServicesID") as! ListOfServicesVC
            vc.objProtocol = self
            vc.servicesList = self.profileData.providerServices!
            return vc
        } else if position == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookAppointmentID") as! BookAppointmentVC
            vc.objProtocol = self
            vc.serviceId = serviceId
            vc.servicesList = self.profileData.providerServices!
            vc.providerId = self.profileData.providerInfo?.id
            vc.list = self.profileData.providerServices!
            //            vc.appointmentId = self.profileData.appointmentDetails?.userDetails.a
            //            vc.date = self.profileData.
            return vc
        }
        return UIViewController()
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension ProfileVC : updateViewSwipeHeight {
    func updateHeight(value: Int) {
        self.viewSwipeHeightConst.constant = CGFloat(value)
        self.view.layoutIfNeeded()
    }
}

extension ProfileVC: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        
    }
}

extension ProfileVC :UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return (self.profileData.providerPortfolio?.count)!
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellForImage = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? PortFolioImageCell
        let cellForVideo = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as? PortFolioVideoCell
        let portfolio = self.profileData.providerPortfolio?[indexPath.row]
        if portfolio?.type == "I" {
            if !(portfolio?.file?.isEmpty)!{
                let url = (profileData.portfolio_url)! as String + (portfolio?.file)!.replacingOccurrences(of: " ", with: "%20") as String
                ImageLoader.sharedLoader.imageForUrl(urlString: url, completionHandler:{(image: UIImage?, url: String) in
                    cellForImage?.imgView.contentMode = .scaleAspectFill
                    cellForImage?.imgView.image = image
                })
            }
            return cellForImage!
        }
        if !(portfolio?.video_thumb?.isEmpty)!{
            let url = (profileData.portfolio_url)! as String + (portfolio?.video_thumb)!.replacingOccurrences(of: " ", with: "%20") as String
            ImageLoader.sharedLoader.imageForUrl(urlString: url, completionHandler:{(image: UIImage?, url: String) in
                cellForVideo?.imgView.contentMode = .scaleAspectFill
                cellForVideo?.imgView.image = image
            })
        }
        return cellForImage!
    }
}

extension ProfileVC :UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let portfolio = self.profileData.providerPortfolio?[indexPath.row]
        if portfolio?.type == "I" {
            // 2. create PhotoBrowser Instance, and present.
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            SKPhotoBrowserOptions.displayAction = false
            present(browser, animated: true, completion: {})
        } else {
            self.playVideo(strVideo: (profileData.portfolio_url)! as String + (portfolio?.file)!.replacingOccurrences(of: " ", with: "%20"))
        }
    }
    
    func playVideo(strVideo:String) {
        let videoURL = URL(string:strVideo)
        let player = AVPlayer(url: videoURL!)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.size.width / 3 - 15, height: collectionView.frame.size.width / 3 - 15)
    }
}

class PortFolioImageCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.borderColor = UIColor.gray.cgColor
        imgView.layer.borderWidth = 0.5
    }
}

class PortFolioVideoCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.borderColor = UIColor.gray.cgColor
        imgView.layer.borderWidth = 0.5
    }
}
