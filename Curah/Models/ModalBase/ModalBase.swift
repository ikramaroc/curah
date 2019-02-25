//
//  ModalBase.swift
//  UnitedCabs
//
//  Created by netset on 8/7/18.
//  Copyright © 2018 netset. All rights reserved.
//

import Foundation
import ObjectMapper

struct ModalBase : Mappable {
    var message : String?
    var status : Int?
    var totalCount : Int?
    var userInfo : UserInfo?
    var mainServices : [Main_services]?
    var imgUrl : String?
    var url : String?
    
    var keywordsWords : [Keywords]?
    var cards : [Cards]?
    // Provider List
    var provider_list : [Provider_list]?
    var connection_id: Int?
    var cardAdded : Bool?
    
    // Sub Services
    var mainService : Main_service?
    var services : [Keywords]?
    
    //My Review List
    var myReviews : [MyReviews]?
    
    // Customer Appointments
    var customerAppointments : [CustomerAppointments]?
    
    
    // Appointment Details
    var appointmentDetails : CustomerAppointments?
    var rating : Rating?
    
    // Messages List
    var connections : [Connections]?
    
    //One to one message conversations
    var conversations :  [conversations]?
    
    // Favorite List
    var favoriteList : [FavoritesList]?
    
    // Other User Profile
    
    var providerInfo : ProviderInfo?
    var providerPortfolio : [ProviderPortfolio]?
    var portfolio_url : String?
    var providerServices : [ProviderServices]?
    
    //History List
    var historyList : [Appointments]?
    
    // send message
    var sendLastMsg : conversations?
    
    var timeSlotsAvailable : [AvailableTimeSlots]?
    
    var notifications : [notifications]?
    
    var bookingId : Int?
    
    
    init?(map:Map) {
        
    }
    
    mutating func mapping(map:Map) {
        message <- map["message"]
        status <- map["status"]
        userInfo <- map["userInfo"]
        mainServices <- map["main_services"]
        imgUrl <- map["img_url"]
        url <- map["url"]
        keywordsWords <- map["keywords"]
        cards <- map["cards"]
        // Provider List
        provider_list <- map["provider_list"]
        
        totalCount <- map["totalCount"]
        
        bookingId <- map["booking_id"]
        
        cardAdded <- map["cardAdded"]
        
        // Sub Services
        mainService <- map["main_service"]
        services <- map["services"]
        
        //My Review List
        myReviews <- map["my_reviews"]
        
         //My connection Id 
        connection_id <- map["connection_id"]
        
        // Customer Appointments
        customerAppointments <- map["customerAppointments"]
        
        // Messages List
        connections <- map["connections"]
        
        // Appointment Details
        appointmentDetails <- map["appointmentDetails"]
        rating <- map["rating"]
        
        //One to one message conversations
        conversations <- map["conversations"]
        
        // Favorite List
        favoriteList <- map["myFavoriteList"]
        
        // Other User Profile
        providerInfo <- map["providerInfo"]
        providerPortfolio <- map["providerPortfolio"]
        portfolio_url <- map["portfolio_url"]
        providerServices <- map["providerServices"]
        
        notifications <- map["notifications"]
        
        //history list
        historyList <- map["history"]
        
        // send message
        sendLastMsg <- map["last_msg"]
        
        // Available Dates
        
        timeSlotsAvailable <- map["data"]
        
    }
}

struct UserInfo : Mappable {
    var id : Int?
    var token : String?
    var firstname : String?
    var lastname : String?
    var address : String?
    var dob : String?
    var phone : String?
    var profileImageUrl : URL?
    var profileImageUrlApi : String?
    var city : String?
    var state : String?
    var rating : String?
    var reviewCount : Int?
    var profileImage : String?
    var latitude : String?
    var longitude : String?
    var notificationType : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        token <- map["token"]
        state <- map["state"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        address <- map["address"]
        dob <- map["dob"]
        phone <- map["phone"]
        profileImageUrlApi <- map["imgUrl"]
        city <- map["city"]
        rating <- map["rating"]
        reviewCount <- map["reviewCount"]
        profileImage <- map["profile_image"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        notificationType <- map["notification_type"]
    }
}

struct Keywords : Mappable {
    var id : Int?
    var name : String?
    var price : String?
    var priceValue : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
    }
}

struct notifications : Mappable {
    var sender_id : Int?
    var receiver_id : Int?
    var notification_id : String?
    var label : String?
    var date : String?
    var type : String?
    var message : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        sender_id <- map["sender_id"]
        receiver_id <- map["receiver_id"]
        notification_id <- map["notification_id"]
        label <- map["label"]
        date <- map["date"]
        type <- map["type"]
        message <- map["message"]
        
    }
}


struct Cards : Mappable {
    var cardId : Int?
    var nameOnCard : String?
    var expYear : String?
    var expMonth : String?
    var cardTypeImgUrl : String?
    var cardType : String?
    var last4 : String?
    var cvv : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        cardId <- map["id"]
        nameOnCard <- map["name"]
        expYear <- map["exp_year"]
        expMonth <- map["exp_month"]
        cardTypeImgUrl <- map["image"]
        cardType <- map["cardType"]
        last4 <- map["last4"]
        cvv <- map["cvc"]
    }
}

struct Main_services : Mappable {
    var id : Int?
    var service_name : String?
    var service_photo : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        service_name <- map["service_name"]
        service_photo <- map["service_photo"]
    }
}

struct Provider_list : Mappable {
    var service_id : Int?
    var id : Int?
    var firstname : String?
    var lastname : String?
    var profileImg : String?
    var price : Int?
    var latitude : String?
    var longitude : String?
    var user_rating : String?
    var distance : Int?
    var connectionId : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        service_id <- map["service_id"]
        id <- map["id"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        profileImg <- map["profile_image"]
        price <- map["price"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        user_rating <- map["user_rating"]
        distance <- map["distance"]
        connectionId <- map["connection_id"]
    }
}


struct Main_service : Mappable {
    var id : Int?
    var service_name : String?
    var service_photo : String?
    var type : String?
    var created_at : String?
    var updated_at : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        service_name <- map["service_name"]
        service_photo <- map["service_photo"]
        type <- map["type"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
}

struct MyReviews : Mappable {
    var firstname : String?
    var lastname : String?
    var profileImg : String?
    var rating : Int?
    var description : String?
    var username : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        profileImg <- map["profile_image"]
        rating <- map["rating"]
        description <- map["description"]
    }
}



struct CustomerAppointments : Mappable {
    var bookingId : Int?
    var price : Int?
    var status : String?
    var userId : Int?
    var serviceName : String?
    var date : String?
    var cancelDescription : String?
    var cancelBy : String?
    var payment_status : String?
    var providerId : Int?
    var address : String?
    var description : String?
    var startTime : String?
    var closeTime : String?
    var serviceNameArr : [Keywords]?
    var userDetails : User_details?


    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        bookingId <- map["booking_id"]
        price <- map["price"]
        status <- map["status"]
        userId <- map["user_id"]
        serviceName <- map["service_name"]
        date <- map["date"]
        cancelDescription <- map["cancel_description"]
        cancelBy <- map["cancel_by"]
        payment_status <- map["payment_status"]
        providerId <- map["provider_id"]
        address <- map["address"]
        description <- map["description"]
        startTime <- map["start_time"]
        closeTime <- map["close_time"]
        serviceNameArr <- map["service_name"]
        userDetails <- map["user_details"]
    }
}

struct Rating : Mappable {
    var providerRating : Int?
    var providerMessage : String?
    var customerRating : Int?
    var customerMessage : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        providerRating <- map["provider_rating"]
        providerMessage <- map["provider_message"]
        customerRating <- map["customer_rating"]
        customerMessage <- map["customer_message"]
    }
}

struct User_details : Mappable {
    var firstname : String?
    var profileImage : String?
    var phone : String?
    var distance : Int?
    var rating : String?
    var id : Int?
    var connection_id : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        firstname <- map["firstname"]
        profileImage <- map["profile_image"]
        phone <- map["phone"]
        distance <- map["distance"]
        rating <- map["rating"]
        id <- map["id"]
        connection_id <- map["connection_id"]
    }
}

struct FavoritesList : Mappable {
    
    var firstname : String?
    var profileImage : String?
    var phone : String?
    var distance : Int?
    var rating : String?
    var id : Int?
    var lastname : String?
    var address : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        firstname <- map["firstname"]
        profileImage <- map["profile_image"]
        phone <- map["phone"]
        distance <- map["distance"]
        rating <- map["user_rating"]
        id <- map["id"]
        lastname <- map["lastname"]
        address <- map["address"]
    }
}

struct conversations : Mappable {
    var userId : Int?
    var userName : String?
    var lastmessage : String?
    var userImage : String?
    var messageImage : String?
    var time : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        userId <- map["user_id"]
        userName <- map["user_name"]
        lastmessage <- map["message"]
        userImage <- map["user_image"]
        messageImage <- map["image"]
        time <- map["time"]
    }
}


struct Connections : Mappable {
    var connectionId : Int?
    var userId : Int?
    var userName : String?
    var lastmessage : String?
    var userImage : String?
    var time : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        connectionId <- map["connection_id"]
        userId <- map["user_id"]
        userName <- map["user_name"]
        lastmessage <- map["lastmessage"]
        userImage <- map["user_image"]
        time <- map["time"]
    }
}
struct ProviderInfo : Mappable {
    var id : Int?
    var firstname : String?
    var lastname : String?
    var profileImage : String?
    var address : String?
    var facebookLink : String?
    var instagramLink : String?
    var latitude : String?
    var longitude : String?
    var identification_card : String?
    var drivingLicense : String?
    var experience : String?
    var distance : Int?
    var rating : String?
    var reviewCount : Int?
    var likeStatus : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        profileImage <- map["profile_image"]
        address <- map["address"]
        facebookLink <- map["facebook_link"]
        instagramLink <- map["instagram_link"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        identification_card <- map["identification_card"]
        drivingLicense <- map["driving_license"]
        experience <- map["experience"]
        distance <- map["distance"]
        rating <- map["rating"]
        reviewCount <- map["review_count"]
        likeStatus <- map["like_status"]
    }
}

struct ProviderServices : Mappable {
    var serviceId : Int?
    var name : String?
    var price : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        serviceId <- map["service_id"]
        name <- map["name"]
        price <- map["price"]
    }
}

struct ProviderPortfolio : Mappable {
    var id : Int?
    var user_id : Int?
    var file : String?
    var title : String?
    var description : String?
    var type : String?
    var video_thumb : String?
    var created_at : String?
    var updated_at : String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        file <- map["file"]
        title <- map["title"]
        description <- map["description"]
        type <- map["type"]
        video_thumb <- map["video_thumb"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
}


struct Appointments : Mappable {
    var bookingId : Int?
    var providerId : Int?
    var startTime : String?
    var closeTime : String?
    var date : String?
    var status : String?
    var price : Int?
    var customerId : Int?
    var serviceName : String?
    var rating : Int?
    var appointmentId : Int?
    var firstName : String?
    var lastName : String?
    var image : String?
    var address : String?
    var workDescription : String?
    var cancelType : String?
    var cancelDescription : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        bookingId <- map["bookingId"]
        bookingId <- map["booking_id"]
        providerId <- map["provider_id"]
        startTime <- map["start_time"]
        closeTime <- map["close_time"]
        date <- map["date"]
        status <- map["status"]
        price <- map["price"]
        customerId <- map["customer_id"]
        serviceName <- map["service_name"]
        rating <- map["rating"]
        appointmentId <- map["appointment_id"]
        firstName <- map["firstname"]
        lastName <- map["lastname"]
        image <- map["image"]
        address <- map["address"]
        workDescription <- map["work_description"]
        cancelType <- map["cancel_type"]
        cancelDescription <- map["cancel_description"]
    }
}

struct AvailableTimeSlots : Mappable {
    var appointmentTimeId : Int?
    var startTime : String?
    var closeTime : String?
    var date : String?
    var status : String?
    var providerId : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        appointmentTimeId <- map["appointmentTime_id"]
        startTime <- map["start_time"]
        closeTime <- map["close_time"]
        date <- map["date"]
        status <- map["status"]
        providerId <- map["provider_id"]
    }
    
}
