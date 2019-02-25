//
//  Extensions.swift
//  Curah
//
//  Created by Netset on 19/07/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func initBackButton(){
        
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(btnBack))
        
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.leftBarButtonItem?.tintColor = .white
        
    }
    
    @objc func btnBack(){
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
  /*  func setSearcBar(bar:UISearchBar,font:UIFont){
        bar.setImage(#imageLiteral(resourceName: "search"), for: .search, state: .normal)
        if let textfield = bar.value(forKey: "searchField") as? UITextField {
            textfield.font = font
            if let backgroundview = textfield.subviews.first {
                // Background color
                backgroundview.backgroundColor = UIColor.white
                // Rounded corner
                backgroundview.layer.cornerRadius = 2;
                backgroundview.clipsToBounds = true;
            }
        }
        
    }*/
}
