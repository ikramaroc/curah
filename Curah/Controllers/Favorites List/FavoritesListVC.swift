//
//  FavoritesListVC.swift
//  QurahApp
//
//  Created by netset on 7/17/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import BGTableViewRowActionWithImage
import FloatRatingView

class FavoritesListVC: BaseClass {
    var favoList : ModalBase!
    @IBOutlet weak var tblVwFavorites: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setupMenuBarButton()
        self.title = "Favorites"
      //  tblVwFavorites.rowHeight = UITableViewAutomaticDimension
        tblVwFavorites.estimatedRowHeight = 90
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getFavorites()
    }
    
    func getFavorites() {
        APIManager.sharedInstance.favoritesListAPI { (response) in
            print(response)
            self.favoList = response
            self.tblVwFavorites.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FavoritesListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.favoList != nil else {
            return 0
        }
        return ((self.favoList.favoriteList?.count)! == 0) ? 1 : (self.favoList.favoriteList?.count)!
    }//emptyCell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.favoList.favoriteList?.count)! == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell")
            cell?.selectionStyle = .none
            return cell!
        }
        let cell : CellFavoritesList = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellFavoritesList
        return self.configureCell(cell: cell, indexpath: indexPath)
    }
    
    func configureCell(cell:CellFavoritesList, indexpath:IndexPath) -> UITableViewCell {
        cell.imgVwUser.clipsToBounds=true
        cell.imgVwUser.layer.cornerRadius = 3.0
        cell.imgVwUser.layer.borderColor = UIColor.black.cgColor
        cell.selectionStyle = .none
        let list = self.favoList.favoriteList?[indexpath.row]
        cell.lblUserName.text = (list?.firstname)! + " " +  (list?.lastname)!
        if !(list?.profileImage?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: cell.imgVwUser.bounds.size.width/2, y: cell.imgVwUser.bounds.size.height/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            cell.imgVwUser.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (self.favoList.url)! as String + (list?.profileImage)! as String, completionHandler:{(image: UIImage?, url: String) in
                cell.imgVwUser.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
            cell.imgVwUser.layer.borderWidth = 0.7
        }
        cell.lblDistance.text = "(\(list?.distance ?? 0) miles away)"
        if let rating = list?.rating {
            cell.ratingView.rating = Double(rating)!
        }
        cell.lblLocation.text = list?.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return ((self.favoList.favoriteList?.count)! == 0) ? false : true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((self.favoList.favoriteList?.count)! == 0) ?  (tableView.frame.size.height-64) : UITableViewAutomaticDimension
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let frame = tableView.rectForRow(at: indexPath)
//        let deleteAction = BGTableViewRowActionWithImage.rowAction(with: UITableViewRowActionStyle.default, title: "Delete", backgroundColor: Constants.Color.k_deleteBackgroundColor, image: #imageLiteral(resourceName: "delete") , forCellHeight: UInt(frame.size.height)) { (action, indexPath) in
//            // Perform an action....
//            let list = self.favoList.favoriteList?[(indexPath?.row)!]
//            let actionSheetController = UIAlertController (title: "Are you sure you want to delete this from favorites ?", message: "", preferredStyle: UIAlertControllerStyle.alert)
//            actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//            //Add Save-Action
//            actionSheetController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
//                self.removeFavoAPI(id: (list?.id)!, row: (indexPath?.row)!)
//            }))
//            //present actionSheetController
//            self.present(actionSheetController, animated:true, completion:nil)
//        }
//        return [deleteAction!]
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.favoList.favoriteList?.count)! != 0 {
            let list = self.favoList.favoriteList?[indexPath.row]
            APIManager.sharedInstance.viewOtherUserProfile(providerId: (list?.id)!) { (response) in
                print(response)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileID") as! ProfileVC
                vc.profileData = response
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func removeFavoAPI(id:Int, row:Int) {
        APIManager.sharedInstance.addOrDeleteFavoAPI(type: Param.unlike.rawValue, providerId: id, response: { (response) in
            print(response)
            self.favoList.favoriteList?.remove(at:row)
            self.tblVwFavorites.reloadData()
        })
    }
}

class CellFavoritesList: UITableViewCell {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
}
