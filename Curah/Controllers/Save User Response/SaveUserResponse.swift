//
//  SaveUserResponse.swift
//  UnitedCabs
//
//  Created by netset on 8/9/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper

class SaveUserResponse: NSObject {
    static let sharedInstance = SaveUserResponse()
     func saveToSharedPrefs(user: ModalBase!) {
        let d = UserDefaults.standard
        if user != nil {
            d.set(Mapper().toJSONString(user, prettyPrint: false) , forKey: "USERDETAILS")
        } else {
            d.set(nil, forKey: "USERDETAILS")
        }
        d.synchronize()
    }
}


