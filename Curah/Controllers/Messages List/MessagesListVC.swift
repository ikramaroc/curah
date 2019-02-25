//
//  MessagesListVC.swift
//  QurahApp
//
//  Created by netset on 7/17/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import BGTableViewRowActionWithImage

class MessagesListVC: BaseClass {
    //MARK:-  OUTLET(S) 
    @IBOutlet weak var tblVwMessages: UITableView!
    //MARK:-  CONSTANT(S) 
    var messageList : ModalBase!
    //MARK:-  LIFE CYCLE(S) 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setupMenuBarButton()
        self.title = "Messages"
        //  tblVwMessages.rowHeight = UITableViewAutomaticDimension
        tblVwMessages.estimatedRowHeight = 80
        
        //chat notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: NSNotification.Name(rawValue: "RefreshNotification"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentScreenStr = "MessagesListVC"
        getMessagesAPI()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Notification Method
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.getMessagesAPI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        currentScreenStr = ""
    }
    
    //MARK:- Get Messages API *******
    
    func getMessagesAPI() {
        APIManager.sharedInstance.getMessagesAPI() { (response) in
            print(response)
            self.messageList = response
            self.tblVwMessages.reloadData()
        }
    }
    
    func deleteUserFromMessagesAPI(connectionId:Int,index:Int) {
        APIManager.sharedInstance.deleteUserInMessageAPI(connectionId: connectionId) {(response) in
            print(response)
            self.messageList.connections?.remove(at: index)
            
            //   self.tblVwMessages.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            //            self.tblVwMessages.deleteRows(at: [index], with: .automatic)
            //            self.messageList = response
            self.tblVwMessages.reloadData()
        }
    }
    
    
    
}

extension MessagesListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.messageList != nil else {
            return 0
        }
        return self.messageList.connections?.count == 0 ? 1 : (self.messageList.connections?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.messageList.connections?.count == 0  {
            let cell : noMessageCell = tableView.dequeueReusableCell(withIdentifier: "noMessageCell") as! noMessageCell
            cell.selectionStyle = .none
            return cell
        }
        let cell : cellMessagesList = tableView.dequeueReusableCell(withIdentifier: "cell") as! cellMessagesList
        return self.configureCell(cell: cell, indexpath: indexPath)
    }
    
    func configureCell(cell:cellMessagesList, indexpath:IndexPath) -> UITableViewCell {
        let data = self.messageList.connections?[indexpath.row]
        cell.imgVwUser.clipsToBounds=true
        cell.lblUserName.text = data?.userName
        
        if data?.lastmessage == nil || data?.lastmessage?.count == 0 {
            cell.lblMessage.text = "image"

        }else{
            cell.lblMessage.text = data?.lastmessage

        }
        
        if !(data?.userImage?.isEmpty)!{
//            cell.lblMessage.text = "image"
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: cell.imgVwUser.bounds.size.width/2, y: cell.imgVwUser.bounds.size.height/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            cell.imgVwUser.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (self.messageList.imgUrl)! as String + (data?.userImage)! as String, completionHandler:{(image: UIImage?, url: String) in
                cell.imgVwUser.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        cell.lblTime.text = convertToLocalDateFormatOnlyTime(utcDate: (data?.time)!)
        cell.imgVwUser.layer.cornerRadius = cell.imgVwUser.frame.size.width/2
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.messageList.connections?.count != 0 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.messageList.connections?.count != 0  {
            
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            newViewController.connection_id = self.messageList.connections?[indexPath.row].connectionId
            newViewController.receiver_id = self.messageList.connections?[indexPath.row].userId
            
            self.navigationController?.pushViewController(newViewController, animated: true)
            
            // self.performSegue(withIdentifier: "segueToChat", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if self.messageList.connections?.count != 0  {
            let frame = tableView.rectForRow(at: indexPath)
            let data = self.messageList.connections?[indexPath.row]
            let deleteAction = BGTableViewRowActionWithImage.rowAction(with: UITableViewRowActionStyle.default, title: "Delete", backgroundColor: Constants.Color.k_deleteBackgroundColor, image: #imageLiteral(resourceName: "delete") , forCellHeight: UInt(frame.size.height)) { (action, indexPath) in
                self.deleteUserFromMessagesAPI(connectionId:(data?.connectionId)!,index:(indexPath?.row)! )
            }
            return [deleteAction!]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.messageList.connections?.count == 0) ? (tableView.frame.size.height-64) : UITableViewAutomaticDimension
    }
    
    
    
}

class cellMessagesList: UITableViewCell {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
}

class noMessageCell: UITableViewCell {
    
}

