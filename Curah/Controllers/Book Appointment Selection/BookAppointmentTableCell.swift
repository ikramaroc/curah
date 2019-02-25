//
//  BookAppointmentTableCell.swift
//  BookAppointmentVc
//
//  Created by netset on 01/08/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class BookAppointmentTableCell: UITableViewCell {
    @IBOutlet var lblServiceName: UILabel!
    @IBOutlet var btnCross: UIButton!
    @IBOutlet var lblServicePrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
