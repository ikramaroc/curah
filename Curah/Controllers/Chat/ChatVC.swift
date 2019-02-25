//
//  ChatVC.swift
//  Curah
//
//  Created by Netset on 2/15/18.
//  Copyright © 2018 Adarsh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import KMPlaceholderTextView
import SDWebImage
import SKPhotoBrowser


class ChatVC: UIViewController {
    
   
    //MARK:- Properties
    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var txtViewMessage: KMPlaceholderTextView!
    @IBOutlet var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var userImgVw: UIImageView!
    @IBOutlet var driverImgVw: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblOtherUserName: UILabel!
    
    let myPickerController = UIImagePickerController()
    var keyboardHeigh: CGFloat?
    var image = UIImage()
    /*   let userInfo = Model.sharedModelInstance.UserJson
     var arrChatList = Array<Messages>()
     var conversationObj : MessageList?
     var customerObj : Customer_Profile?
     var driverObj : DriverProfile_Base?
     var driverTrackLocObj : My_moves?*/
    var notificationObj : AnyObject?
    var connection_id : Int!
    var receiver_id: Int!
    fileprivate var images = [SKPhoto]()

    
    //MARK:-  CONSTANT(S) 
    var messageList : ModalBase!
    //MARK:-  LIFE CYCLE(S) 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat"
        self.dismiss(animated: true, completion: nil)
        
        otherUserIdForChat = receiver_id
        self.uiInisilizer()
        //Get Message List
        
        if connection_id != 0{
            self.getMessageList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentScreenStr = "ChatVC"
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        NotificationCenter.default.addObserver(self,selector: #selector(ChatVC.keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        //chat notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: NSNotification.Name(rawValue: "RefreshNotification"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        otherUserIdForChat = 0
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        bottomViewHeight.constant = 0
        self.viewHeight.constant = 50
        self.view.layoutIfNeeded()
        NotificationCenter.default.removeObserver(self)
        // NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NotificationMessage"), object: nil);
    }
    
  
    
    
    //MARK:- Get Message List
    func getMessageList(){
        APIManager.sharedInstance.getOneToOneMessagesListAPI(connectionId: connection_id,receiverId: receiver_id!) { (response) in
            print(response)
            self.messageList = response
            self.chatTableView.reloadData()
            self.scrollToBottom()
        }
    }
    
    //MARK:- Send Text Message
    func sendMessage(messageStr:String){
        APIManager.sharedInstance.sendTextMessage(receiverId: receiver_id, message: messageStr){ (response) in
            print(response)
            self.connection_id = response.connection_id!
            if self.messageList != nil{
                self.messageList.conversations?.append(response.sendLastMsg!)
                self.chatTableView.reloadData()
                self.scrollToBottom()
            }else {
                self.getMessageList()
            }
        }
    }
    
    //MARK:- Send Image Message
    func sendImageMessage(image:UIImage){
        APIManager.sharedInstance.sendImageMessageAPI(image:image, receiverId: receiver_id) { (response) in
            print(response)
            self.connection_id = response.connection_id!
            if self.messageList != nil{
                self.messageList.conversations?.append(response.sendLastMsg!)
                self.chatTableView.reloadData()
                self.scrollToBottom()
                //self.getMessageList()
            }else {
                self.getMessageList()
            }
        }
    }
    
    //MARK:- Notification Method
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.getMessageList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIInisilizer
    func uiInisilizer(){
        myPickerController.delegate = self;
        myPickerController.allowsEditing = true
        //     CommonMethod.shared.changePickerViewBGColor(pickerView: myPickerController)
        chatTableView.estimatedRowHeight = UITableViewAutomaticDimension
        chatTableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    //MARK:- Set User Profile Info
    func fetchProfileInfo(driverImgUrl:String?,otherUserName:String?){
        
    }
    
    //MARK:- Keyboard Hide/Show Method
    @objc func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeigh = keyboardRectangle.height
        bottomViewHeight.constant = -keyboardHeigh!
        self.view.layoutIfNeeded()
        scrollToBottom()
        
    }
    
   
    
    @objc func keyboardWillHide(notification:NSNotification){
        bottomViewHeight.constant = 0
        self.view.layoutIfNeeded()
        scrollToBottom()
        
    }
    
    //MARK:- Action Button
    @IBAction func btnBack_action(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Send ImageButton
    @IBAction func btnSendImage_action(_ sender: UIButton) {
        self.showActionSheet()
    }
    
    @IBAction func btnSendMessage_action(_ sender: UIButton) {
        // self.view.endEditing(true)
        if txtViewMessage.text.count > 1  && txtViewMessage.text?.trimmingCharacters(in: .whitespaces) != ""{
            
            sendMessage(messageStr: txtViewMessage.text!)
            
            self.chatTableView.reloadData()
            self.scrollToBottom()
            self.viewHeight.constant = 50
            self.txtViewMessage.text = nil
        }else{
            txtViewMessage.text = nil
            self.viewHeight.constant = 50
        }
    }
    
    
    
    func scrollToBottom(){
        if messageList != nil{
            
            if (messageList?.conversations?.count)! > 0
            {
                chatTableView.scrollToRow(at: IndexPath(row: (messageList?.conversations?.count)! - 1, section: 0), at: .bottom, animated: false)
            }}
    }
    
   
    
}

//MARK:- TableView Delegate and DataSource
extension ChatVC : UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.messageList != nil else {
            return 0
        }
        return self.messageList.conversations?.count == 0 ? 0 : (self.messageList.conversations?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:ChatTableCell? = nil
        
        
        let data = self.messageList.conversations?[indexPath.row]
        if (data!.messageImage!.count) == 0
        {
            if data!.userId! == ModalShareInstance.shareInstance.modalUserData?.userInfo?.id!
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as? ChatTableCell
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as? ChatTableCell
            }
            cell?.lblMsg.text = data?.lastmessage
            
        }
        else
        {
            if data!.userId! == ModalShareInstance.shareInstance.modalUserData?.userInfo?.id!
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as? ChatTableCell
                
               

                if (data!.messageImage!.count != 0) {
                    
                    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    activityView.center = CGPoint(x: (cell!.imgView.bounds.size.width)/2, y: (cell!.imgView.bounds.size.height)/2)
                    activityView.color = UIColor.lightGray
                    activityView.startAnimating()
                    cell?.imgView.addSubview(activityView)
                    
                    cell!.imgView.image = nil
                    cell!.imgView.sd_setHighlightedImage(with: URL(string: (self.messageList.url)! as String + (data!.messageImage!)), options: .highPriority, completed: { (image, error, cache, url) in
                        cell!.imgView.image = image!
                        activityView.stopAnimating()
                        activityView.removeFromSuperview()
                    })
                    
                   
                    cell!.imgView.isUserInteractionEnabled = true
                    
//                    ImageLoader.sharedLoader.imageForUrl(urlString: (self.messageList.url)! as String + (data!.messageImage!) as String, completionHandler:{(image: UIImage?, url: String) in
//                        cell!.imgView.image = image
//                        activityView.stopAnimating()
//                        activityView.removeFromSuperview()
//                    })
                }
                
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as? ChatTableCell

                if (data!.messageImage!.count != 0) {

                    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    activityView.center = CGPoint(x: (cell!.imgView.bounds.size.width)/2, y: (cell!.imgView.bounds.size.height)/2)
                    activityView.color = UIColor.lightGray
                    activityView.startAnimating()
                    cell?.imgView.addSubview(activityView)
                    
                     cell!.imgView.image = nil
                    cell!.imgView.sd_setHighlightedImage(with: URL(string: (self.messageList.url)! as String + (data!.messageImage!)), options: .highPriority, completed: { (image, error, cache, url) in
                        cell!.imgView.image = image!
                        activityView.stopAnimating()
                        activityView.removeFromSuperview()
                    })
                    cell!.imgView.isUserInteractionEnabled = true
                }
            }
        }
        
        cell?.timeLbl.text = convertToLocalDateFormatOnlyTime(utcDate: (data?.time)!)
        cell?.lblUserName.text = data?.userName
        
 
        
        if !(data?.userImage?.isEmpty)!{
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = CGPoint(x: (cell?.userImgVw.bounds.size.width)!/2, y: (cell?.userImgVw.bounds.size.height)!/2)
            activityView.color = UIColor.lightGray
            activityView.startAnimating()
            cell?.userImgVw.addSubview(activityView)
            ImageLoader.sharedLoader.imageForUrl(urlString: (self.messageList.imgUrl)! as String + (data!.userImage!) as String, completionHandler:{(image: UIImage?, url: String) in
                cell?.userImgVw.image = image
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            })
        }
        
        
        cell?.layoutIfNeeded()
        cell?.setNeedsLayout()
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0{
//            return 0
//        }
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let data = self.messageList.conversations?[indexPath.row]

        if (data!.messageImage!.count != 0)
        {
            images.removeAll()
            let photo = SKPhoto.photoWithImageURL((self.messageList.url)! as String + (data!.messageImage!).replacingOccurrences(of: " ", with: "%20"))
            photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
            images.append(photo)

            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            SKPhotoBrowserOptions.displayAction = false
            present(browser, animated: true, completion: {})
        }
    }
    
    
   
    
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
     
        var position: CGPoint =  sender.location(in: self.chatTableView)
        var indexPath: IndexPath = self.chatTableView.indexPathForRow(at: position)! as IndexPath
        
        let data = self.messageList.conversations?[indexPath.row]
        
        if (data!.messageImage!.count != 0)
        {
            images.removeAll()
            let photo = SKPhoto.photoWithImageURL((self.messageList.imgUrl)! as String + (data!.userImage!).replacingOccurrences(of: " ", with: "%20"))
            photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
            images.append(photo)
            
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            SKPhotoBrowserOptions.displayAction = false
            present(browser, animated: true, completion: {})
        }
    }
}

//MARK:- Send Image Extension
extension ChatVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Choose Option", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            myPickerController.sourceType = UIImagePickerControllerSourceType.camera
            myPickerController.cameraCaptureMode = .photo
            myPickerController.allowsEditing = true
            present(myPickerController, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func photoLibrary(){
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    //UIImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
       if let pickedImage = info[UIImagePickerControllerEditedImage]  as? UIImage ?? info[UIImagePickerControllerOriginalImage] as? UIImage
       {
            sendImageMessage(image: pickedImage)
            
            chatTableView.reloadData()
            self.scrollToBottom()
            //self.webServiceSendImagePI(params as NSDictionary)
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- TextView Delegate
extension ChatVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if textView.contentSize.height > textView.frame.size.height {
            if self.viewHeight.constant < 80{
                self.viewHeight.constant = textView.contentSize.height
            }
        }else if isBackSpace == -92{
            if textView.contentSize.height < 80 && textView.contentSize.height > 32{
                self.viewHeight.constant = textView.contentSize.height
            }
        }
        return true
    }
}
