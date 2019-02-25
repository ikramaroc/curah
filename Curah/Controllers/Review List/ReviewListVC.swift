//
//  ReviewListVC.swift
//  QurahApp
//
//  Created by netset on 7/17/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import FloatRatingView

class ReviewListVC: BaseClass {

    @IBOutlet weak var tblVwReview: UITableView!
    var reviews:ModalBase!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reviews"
        super.setupBackBtn(tintClr: .white)
        tblVwReview.rowHeight = UITableViewAutomaticDimension
        tblVwReview.estimatedRowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ReviewListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (reviews.myReviews?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CellReviewList = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellReviewList
        return self.configureCell(cell: cell, indexpath: indexPath)
    }
    
    func configureCell(cell:CellReviewList, indexpath:IndexPath) -> UITableViewCell {
        let data = reviews.myReviews?[indexpath.row]
        cell.lblUserName.text = (data?.firstname)! + " " +  (data?.lastname)!
        cell.imgVwUser.clipsToBounds=true
        cell.imgVwUser.layer.cornerRadius = cell.imgVwUser.frame.size.width/2
        if !(data?.profileImg?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: cell.imgVwUser.bounds.size.width/2, y: cell.imgVwUser.bounds.size.height/2)
            activityView.color = Constants.appColor.appColorMainPurple
            activityView.startAnimating()
            cell.imgVwUser.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (reviews.imgUrl)! + (data?.profileImg)! as String, completionHandler:{(image: UIImage?, url: String) in
                cell.imgVwUser.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        if let rating = data?.rating {
            cell.ratingVw.rating = Double(rating)
        }
        cell.lblDecription.text = data?.description
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
  /*  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let frame = tableView.rectForRow(at: indexPath)
        let deleteAction = BGTableViewRowActionWithImage.rowAction(with: UITableViewRowActionStyle.default, title: "Delete", backgroundColor: Constants.Color.k_deleteBackgroundColor, image: #imageLiteral(resourceName: "delete") , forCellHeight: UInt(frame.size.height)) { (action, indexPath) in
            // Perform an action....
        }
        return [deleteAction!]
    }*/
}

class CellReviewList: UITableViewCell {
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ratingVw: FloatRatingView!
    @IBOutlet weak var lblDecription: UILabel!
}
