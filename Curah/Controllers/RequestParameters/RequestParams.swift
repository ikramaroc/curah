//
//  RequestParams.swift
//  Shopaves
//
//  Created by Shopaves on 20/04/18.
//  Created by Shopaves. All rights reserved.
//

import Foundation

//Sign up Params
enum Param : String {
    
    // MARK:- create account
    case email = "email"
    case password = "password"
    case registerType = "register_type"
    case socialId = "social_id"
    case facebook = "F"
    case google = "G"
    case others = "O"
    case apple = "A"
    case authToken = "token"
    case cardToken = "card_token"
    case paymentType = "payment_type"
    case ios = "I"
     case appType = "apptype"
   
    // ****************
    
    
    // MARK:-  login
    case deviceId = "device_id"
    case userType = "user_type"
    case serviceProvider = "S"
    case customer = "C"
    case customerId = "customer_id"
    case profileId = "profile_id"
    case deviceType = "device_type"
//    case notificationStatus = "type"
    //case ios = "I"

    // ****************
    
    
    // MARK:-  Create Profile
    case firstName = "firstname"
    case lastName = "lastname"
    case dateOfBirth = "dob"
    case mobileNumber = "phone"
    case profileImage = "profile_image"
    case address = "address"
    case user = "user_id"
    
    case oldPassword = "old_password"
    case newPassword = "new_password"
    
    
    // ****************
    
    
    // MARK:-  Add/Edit CArd
    case cardNumber = "card_number"
    case name = "name"
    case expMonth = "exp_month"
    case exp_year = "exp_year"
    case cvv = "cvc"
    case cardId = "card_id"
    // ****************
    
    // MARK:-  Provider List
    case serviceId = "service_id"
    case mainServiceId = "mainServiceId"
    case priceRange = "price_range"
    case distance = "max_distance"
    case paginationIndex = "page"
    case latitude = "latitude"
    case longitude = "longitude"
    case lowToHigh = "L"
    case highToLow = "H"
    // ****************
    
    
    // MARK:-  Add Suggested Service
    case serviceName = "category_name"
    // ****************
    
    
    // MARK:-  Notifications
    case status = "type"
    case on = "ON"
    case off = "OFF"
    
    // ****************
    
    
    // MARK:-  Appointment Details
    case bookingId = "booking_id"
    case cancelDesc = "cancel_description"
    case reasonForCancel = "Service Provider has not accept the request."
    case providerId = "provider_id"
    // ****************
    
    
    
    // MARK:-  Favorites
   // case like = "L" /// Same as lowToHigh
    case unlike = "U"
    // ****************
    
    
    // MARK:-  Contact Us
    case subject = "subject"
    case message = "message"
    // ****************
    
    
    
    
    
    
    
    case contentType = "Content-Type"
    case auth = "Authorization"
    case appVersion = "version"
    case deviceTypeName = "IOS"
    case id = "id"
    case venue = "venue"
    case favoIds = "favoriteIds"

    // Verify Account
    case code = "verificationCode"
    case gender = "gender"
    case anonymous = "anonymous"
    case countryCode = "countryCode"
    case userAuth = "userAuth"
    case username = "username"
    
    case city = "city"
    case state = "state"
    case country = "country"
    case zipCode = "zipCode"
    case shippingAddresss = "shippingAddresss"
    case userPreference = "userPreference"
    case cities = "cities"
    case colors = "colors"
    case brands = "brands"
    case styles = "styles"
    case tags = "tags"
    case categories = "categories"
    case socialAccounts = "socialAccounts"
    case appId = "appId"
    
    // Delete connections in messages
    case connectionId = "connection_id"
    
    // Get conversations one to one in messages
    case receiverId = "receiver_id"
    case senderId = "sender_id"
  //  case messageTxt = "message"
    case image = "image"
    
    
   case date = "date"
    
    
    // Appointment Booking
    case appointmentId = "appointment_id"
    case price = "price"
    case amount = "amount"
    case sepratePrice = "seprate_price"
    case workDescription = "work_description"
    case description = "description"

    
    //Rating
    case raterId = "rater_id"
    case ratableId = "ratable_id"
    case rating = "rating"
}


enum BookingStatus : String {
    // STATUS
    case accept = "A"
    case reject = "R"
    case inProgress = "I"
    case cancelled = "K"
    case waiting = "P"
    case completed = "C"
}



enum segueId : String {
    case createProfile = "segueCreateProfile"
    case loginToCreateProfile = "segueLoginToCreateProfile"
    case providerList = "segueProviderList"
    case subServices = "segueToHair"
    case subServicesOthers = "segueToOtherServices"
    
    
    case editProfile = "editProfileSegue"
    case myCards = "segueMyCardsVC"
    case myReviews = "segueReviewsVC"
    case detail = "segueDetailVC"
    case cancelAppointment = "segueCancelAppointmentVC"
    
    
    
    
    
}
