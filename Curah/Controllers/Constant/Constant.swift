//
//  Constant.swift
//  WalFly
//
//  Created by Ranjana Prashar on 4/10/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import Foundation
import UIKit
internal struct Constants {
    private enum BaseUrl : String {
        case live  = "https://curahapp.com/webservice/"
        //        case local = "http://192.168.2.252/curah/webservice/"
        case local = "http://192.168.2.39/allproject/curah/webservice/"
    }
    
    struct Color {
        static let k_deleteBackgroundColor: UIColor = UIColor(red: 247.0/255.0, green: 0.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        static let k_PinkColor: UIColor = UIColor(red: 198.0/255.0, green: 150.0/255.0, blue: 174.0/255.0, alpha: 1.0)
    }
    
    struct APIConstantNames {
        static let baseUrl = BaseUrl.live.rawValue
        static let version = ""
        static let login = APIConstantNames.baseUrl + "login"
        static let forgotPassword = APIConstantNames.baseUrl + "forgotPassword"
        static let signUp = APIConstantNames.baseUrl + "createAccount"
        static let createProfile = APIConstantNames.baseUrl + "createProfile"
        static let getMainServices = APIConstantNames.baseUrl + "getMainServices"
        static let getServices = APIConstantNames.baseUrl + "getServices"
        static let addCard = APIConstantNames.baseUrl + "addCard"
        static let listCard = APIConstantNames.baseUrl + "cardList"
        static let editCard = APIConstantNames.baseUrl + "editCard"
        static let providerList = APIConstantNames.baseUrl + "providerList"
        static let suggestedService = APIConstantNames.baseUrl + "SuggestCatName"
        static let changeNotification = APIConstantNames.baseUrl + "changeNotification"
        static let getReviewList = APIConstantNames.baseUrl + "myReviews"
        static let appointmentList = APIConstantNames.baseUrl + "customerAppointments"
        static let appointmentDetail = APIConstantNames.baseUrl + "appointmentDetail"
        static let getMessages = APIConstantNames.baseUrl + "messages"
        static let deleteUserInMessages = APIConstantNames.baseUrl + "deleteConnections"
        static let getOneToOneMessagesList = APIConstantNames.baseUrl + "getConversations"
        static let sendMessage = APIConstantNames.baseUrl + "sendMessage"
        static let cancelAppointment = APIConstantNames.baseUrl + "cancelAppointment"
        static let favoList = APIConstantNames.baseUrl + "myFavorites"
        static let addOrDeleteFavo = APIConstantNames.baseUrl + "likeUnlikeUser"
        static let contactUs = APIConstantNames.baseUrl + "contactUs"
        static let changePassword = APIConstantNames.baseUrl + "changePassword"
        static let otherUserProfile = APIConstantNames.baseUrl + "ServiceProviderProfile"
        static let getHistoryList = APIConstantNames.baseUrl + "history"
        static let seeAvailableTimeSlots = APIConstantNames.baseUrl + "seeAppointment"
        static let appointmentBooking = APIConstantNames.baseUrl + "appointmentBooking"
        static let getNotification = APIConstantNames.baseUrl + "getNotification"
        static let rateUser = APIConstantNames.baseUrl + "rating"
        static let makePayment = APIConstantNames.baseUrl + "payment"
        static let applePay = APIConstantNames.baseUrl + "appleAndroidPay"
        static let pendingPayment = APIConstantNames.baseUrl + "pendingPayment"
        static let deleteCard = APIConstantNames.baseUrl + "deleteCard"
        
    }
    
    struct appColor{
        static let appColorMainGreen : UIColor = UIColor(red: 198.0/255.0, green: 213.0/255.0, blue: 150.0/255.0, alpha: 1)
        static let appColorMainPurple : UIColor = UIColor(red: 90.0/255.0, green: 30.0/255.0, blue: 85.0/255.0, alpha: 1)
    }
    
    //MARK:- FONTS USED IN APP:--
    struct AppFont{
        static let fontHeavy = "AvenirLTStd-Heavy"
        static let fontRoman = "AvenirLTStd-Roman"
        static let fontAvenirRoman = "Avenir-Roman"
        static let fontAvenirBook = "Avenir-Book"
        static let fontAvenirHeavy = "Avenir-Heavy"
        static let fontAvenirMedium = "Avenir-Medium"
    }
    
    struct App {
        static let name = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    }
}
