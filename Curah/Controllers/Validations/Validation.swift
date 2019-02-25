//
//  Validation.swift
//  Adeeb
//
//  Created by Apple on 09/12/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit

class Validation: NSObject {
    struct call {
        static let noInternet = "Internet connection seems to be offline"
        
        // Stores
        static let selectedCount3 = "Choose at least 3 options to continue"
        static let selectedCount1 = "Choose at least 1 option to continue"
        
        
        
        // Login
        static let enterEmail = "Please enter email address"
        static let validEmail = "Please enter a valid email address"
        static let enterPassword = "Please enter password"
         static let enterOldPassword = "Please enter old password"
        static let enterNewPassword = "Please enter new password"
        static let enterConfirmPassword = "Please enter confirm password"
        static let passwordNotMatch = "Password not match"
        static let passwordLimit = "Password must be at least 8 characters"
        static let acceptTermsPrivacy = "Please accept Privacy Policy & Terms of Service"
    
        static let facebookLinkNotAvailable = "Facebook link is not provided"
        static let instagramLinkNotAvailable = "Instagram link is not provided"
        
        
        static let selectGender = "Please select gender"

        // Forgot Password
        static let registeredEmail = "Please enter your registered email address"
        
        // SignUp
        static let userName = "Please enter user name"
        static let firstName = "Please enter first name"
        static let lastName = "Please enter last name"
        static let phone = "Please enter phone address"
        static let dob = "Please enter date of birth"
        static let photo = "Please upload photo"

        
        // SignUp
        static let enterAddress = "Please enter address 1"
        static let state = "Please enter state"
        static let city = "Please enter city"
        static let country = "Please enter country"
        static let zipCode = "Please enter zip code"
        
        
        // Add new card
        static let name = "Please enter your name"
        static let cardNumber = "Please enter card number"
        static let validCardNumber = "Please enter valid card number"
        static let expiryDate = "Please select expiry date"
        static let cvv = "Please enter cvv"
        
         static let enterYourName = "Please enter your name"
        static let enterSubject   = "Please enter subject"
        static let entermessage   = "Please enter message"
        
        static let noSessionAvailable = "No sessions available for selected date"
        static let selectASession = "Please select a session to apply"

        static let provideRating = "Please provide rating"
        static let enterDescriptionText = "Please enter description"
        
        static let noAppointments = "No appointments available for selected date, please select another date"

        
    }
    
    struct row {
        static let height = 70.0
    }
    
    struct notificationRow {
        static let ipadHeight = 90.0
        static let height = 60.0
    }
    
    struct headerHeight {
        static let iphone = 40.0
        static let ipad = 60.0
    }
}
