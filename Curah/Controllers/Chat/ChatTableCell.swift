//
//  ChatTableCell.swift
//  EasyMove
//
//  Created by Adarsh on 2/15/18.
//  Copyright © 2018 Adarsh. All rights reserved.
//

import UIKit

class ChatTableCell: UITableViewCell {
    
    //Cell outlet
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var userImgVw: UIImageView!
    @IBOutlet var lblMsg: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var timeLbl :UILabel!
  
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
