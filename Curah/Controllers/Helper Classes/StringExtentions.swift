//
//  StringExtentions.swift
//  WalFly
//
//  Created by Ranjana Prashar on 4/10/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import Foundation
extension String
{
    func whiteSpaceCount(text:String) -> Int {
    return text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).count
        
    }
    
    //MARK: Email validation Method
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    
}

