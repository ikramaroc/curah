//
//  ProfileVC.swift
//  CurahApp
//
//  Created by Netset on 28/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit

class ProfileVC: BaseClass {
    let tabs = [
        ViewPagerTab(title: "List of Services", image: nil),
        ViewPagerTab(title: "Book Appointment", image: nil),
        ]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintHeightSwipeView: NSLayoutConstraint!
    @IBOutlet weak var viewSwipe: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeView()
        setNavigationBarWithBackBtnAndTitle(title: "Kim Joy")
       // setupMenuBarButton()
        
      /*  let editBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "editWhiteCircle"), style: .plain, target: self, action: #selector(btnEdit))
        
        navigationItem.rightBarButtonItem = editBtn
        navigationItem.rightBarButtonItem?.tintColor = .white*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.height / 2
        //options.viewPagerFrame = self.viewSwipe.bounds
    }
    
    @IBAction func btnChatAct(_ sender: Any) {
        self.performSegue(withIdentifier: "segueChatVC", sender: nil)
    }
    
    @objc func btnEdit(){
        
   //  let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        
     //navigationController?.pushViewController(vc, animated: true)
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
    
    
}

extension ProfileVC: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
       if position == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListOfServicesID") as! ListOfServicesVC
            return vc
        }else if position == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookAppointmentID") as! BookAppointmentVC
            return vc
        }/*else if position == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleVC") as! ScheduleVC
            return vc
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyDocumentsVC") as! MyDocumentsVC
            return vc
        }*/
        return UIViewController()
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
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
        return 12
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if indexPath.row % 2 == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? PortFolioImageCell {
                return cell
            }
        }else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as? PortFolioVideoCell {
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension ProfileVC :UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
