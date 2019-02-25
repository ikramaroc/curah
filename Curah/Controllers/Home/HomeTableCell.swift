//
//  HomeTableCell.swift
//  QurahApp
//
//  Created by netset on 7/16/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
