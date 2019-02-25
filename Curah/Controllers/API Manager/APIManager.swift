//
//  APIManager.swift
//  Curah
//
//  Created by netset on 8/21/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import CoreLocation
import ObjectMapper
import AlamofireObjectMapper

class APIManager: NSObject {
    
    typealias Response = (ModalBase) -> Void
    static let sharedInstance = APIManager()
    let locale = String(Locale.current.identifier)
    //    let userId = ModalShareInstance.shareInstance.modalUserData.userInfo?.id
    
    func headers() ->  [String:String] {
        var appVersion = String()
        var token : String = ""
        if let info = Bundle.main.infoDictionary {
            appVersion = info["CFBundleShortVersionString"] as? String ?? "1.0"
        }
        if ModalShareInstance.shareInstance.modalUserData != nil {
            token = (ModalShareInstance.shareInstance.modalUserData.userInfo?.token!)!
        }
        let headers = [
            Param.appVersion.rawValue : appVersion,
            Param.authToken.rawValue : token,
            Param.status.rawValue : Param.ios.rawValue,
            Param.appType.rawValue : Param.customer.rawValue]
        // Param.authToken.rawValue : "aqmT0SggJ"]
        print(headers)
        return headers
    }
    
    /// MARK:- *********************** Login API ***********************
    func loginAPI(email:String,password:String,token:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.login)"
            print(url)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.getCurrentLocation()
            let loc =  appDelegate.getLocation()
            let params : Dictionary = [Param.email.rawValue:email, Param.password.rawValue:password, Param.deviceId.rawValue:token , Param.userType.rawValue:Param.customer.rawValue,Param.deviceType.rawValue:"I",Param.latitude.rawValue:loc.coordinate.latitude,Param.longitude.rawValue:loc.coordinate.longitude] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                print(JSON)
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    /// MARK:- *********************** Forgot Password API ***********************
    func forgotPasswordAPI(email:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.forgotPassword)"
            print(url)
            let params : Dictionary = [Param.email.rawValue:email] as [String : String]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    //
    // MARK:- *********************** Make payment API ***********************
    func makePaymentAPI(bookingId:Int,cardId:Int,providerId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.makePayment)"
            print(url)
            
            let params : Dictionary = [Param.customerId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.providerId.rawValue:providerId,
                                       Param.bookingId.rawValue:bookingId,
                                       Param.cardId.rawValue : cardId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Delete card API ***********************
    func deleteCardAPI(cardId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.deleteCard)"
            print(url)
            
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.cardId.rawValue:cardId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** Forgot Password API ***********************
    func appointmentDetailAPI(bookingId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.appointmentDetail)"
            print(url)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.getCurrentLocation()
            let loc =  appDelegate.getLocation()
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.userType.rawValue:Param.customer.rawValue,
                                       Param.bookingId.rawValue:bookingId,
                                       Param.latitude.rawValue:loc.coordinate.latitude,
                                       Param.longitude.rawValue:loc.coordinate.longitude] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Appointment booking API ***********************
    func appointmentBookingAPI(appointmentId:Int, serviceId:String, price:Int, sepratePrice:String, providerId:Int, address:String, workDescription:String,paymentType:String,cardId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.appointmentBooking)"
            print(url)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.userType.rawValue:Param.customer.rawValue,
                                       Param.appointmentId.rawValue:appointmentId,
                                       Param.serviceId.rawValue:serviceId,
                                       Param.price.rawValue:price,
                                       Param.sepratePrice.rawValue:sepratePrice,
                                       Param.providerId.rawValue:providerId,
                                       Param.address.rawValue:address,
                                       Param.workDescription.rawValue:workDescription,
                                       Param.paymentType.rawValue : paymentType,
                                       Param.cardId.rawValue: cardId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- ********************** History List API **********************
    func getHistoryList(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getHistoryList)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.userType.rawValue:Param.customer.rawValue] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- ********************** Payment status API **********************
    func getPaymentStatus(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.pendingPayment)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.userType.rawValue:Param.customer.rawValue] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    /// MARK:- *********************** Give rating API ***********************
    func giveRatingAPI(otherUserId:Int,bookingId:Int,ratingValue:Int,description:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.rateUser)"
            print(url)
            let params : Dictionary = [Param.raterId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.ratableId.rawValue:otherUserId, Param.bookingId.rawValue:bookingId, Param.rating.rawValue:ratingValue, Param.description.rawValue:description] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- ********************** Appointment selected date sessions API **********************
    func getAppointmentSessions(providerId:Int,date:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            //            self.showHud()
            let url =  "\(Constants.APIConstantNames.seeAvailableTimeSlots)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.userType.rawValue:Param.customer.rawValue, Param.providerId.rawValue:providerId, Param.date.rawValue:date] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- ********************** Notification List API **********************
    func getNotificationList(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getNotification)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.userType.rawValue:Param.customer.rawValue] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Review List API ***********************
    func getReviewListAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getReviewList)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.profileId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Review List API ***********************
    func getOtherUserReviewListAPI(otherUserId:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getReviewList)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.profileId.rawValue:otherUserId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Apple pay API ***********************
    func applePayments(bookingId:Int,providerId:Int,amount:Int,token:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.applePay)"
            print(url)
            let params : Dictionary = [Param.customerId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.providerId.rawValue:providerId,Param.bookingId.rawValue:bookingId,Param.amount.rawValue:amount,Param.cardToken.rawValue:token,Param.paymentType.rawValue:Param.apple.rawValue] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** Favorites List API ***********************
    func favoritesListAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.favoList)"
            print(url)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.getCurrentLocation()
            let loc =  appDelegate.getLocation()
            let params : Dictionary = [Param.customerId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.latitude.rawValue:loc.coordinate.latitude,
                                       Param.longitude.rawValue:loc.coordinate.longitude] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Delete Favorite API ***********************
    func addOrDeleteFavoAPI(type:String, providerId: Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.addOrDeleteFavo)"
            print(url)
            let params : Dictionary = [Param.customerId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.providerId.rawValue:providerId,
                                       Param.status.rawValue:type] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Contact Us API ***********************
    func contactUsAPI(name:String, subject:String, email:String, message:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.contactUs)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.name.rawValue:name,
                                       Param.subject.rawValue:subject,
                                       Param.email.rawValue:email,
                                       Param.message.rawValue:message] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Contact Us API ***********************
    func changePasswordAPI(currentPassword:String, newPassword:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.changePassword)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.oldPassword.rawValue:currentPassword,Param.newPassword.rawValue:newPassword] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** Review List API ***********************
    func getAppointmentListAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.appointmentList)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** View Available Time Slots API ***********************
    func viewAvailableTimeSlotsAPI(providerId:Int, date:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.seeAvailableTimeSlots)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.providerId.rawValue:providerId,
                                       Param.date.rawValue:date] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** View Available Time Slots API ***********************
    func bookAppointmentAPI(providerId:Int, appointmentId:Int,serviceId:Int,separatePrice:String,totalPrice:Int, address:String, desc:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.appointmentBooking)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.providerId.rawValue:providerId,
                                       Param.appointmentId.rawValue:appointmentId,
                                       Param.serviceId.rawValue:serviceId,
                                       Param.price.rawValue:totalPrice,
                                       Param.sepratePrice.rawValue:separatePrice,
                                       Param.address.rawValue:address,
                                       Param.workDescription.rawValue:desc] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    /// MARK:- *********************** Sign Up (Create Account) API ***********************
    func signUpAPI(email:String,password:String,registerType:String,socialId:String,token:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.signUp)"
            print(url)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.getCurrentLocation()
            let loc =  appDelegate.getLocation()
            
            let params : Dictionary = [Param.email.rawValue:email,
                                       Param.password.rawValue:password,
                                       Param.registerType.rawValue:registerType,
                                       Param.socialId.rawValue:socialId,
                                       Param.deviceId.rawValue:token,
                                       Param.userType.rawValue:Param.customer.rawValue,
                                       Param.deviceType.rawValue:"I",
                                       Param.latitude.rawValue:loc.coordinate.latitude,
                                       Param.longitude.rawValue:loc.coordinate.longitude] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    /// MARK:- *********************** Home Screen ((getMainServices) screen 14) API ***********************
    func getMainSevicesAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getMainServices)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    /// MARK:- *********************** Sub Categories Screen ((getServices)) API ***********************
    func addSuggested_SeviceAPI(name:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.suggestedService)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.serviceName.rawValue:name] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    ///MARK:- Add Other Suggested Service (SuggestCategoryName(SuggestCatName) screen 20) API ***********************
    
    func getSevicesAPI(mainServiceId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getServices)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.mainServiceId.rawValue:mainServiceId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
 
    
    /// MARK:- *********************** Add card (addCard screen 13) API ***********************
    func addCardAPI(cardNo:Int,name:String,expirationDate:String,cvv:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.addCard)"
            print(url)
            // let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.cardNumber.rawValue:cardNo,
                                       Param.name.rawValue:name,
                                       Param.exp_year.rawValue:expirationDate.suffix(2),
                                       Param.expMonth.rawValue:expirationDate.prefix(2),
                                       Param.cvv.rawValue:cvv
                ] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    /// MARK:- *********************** Edit card (addCard screen 13) API ***********************
    func editCardAPI(cardNo:Int,name:String,expirationDate:String,cvv:Int,cardId:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.editCard)"
            print(url)
            // let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.cardNumber.rawValue:cardNo,
                                       Param.name.rawValue:name,
                                       Param.exp_year.rawValue:expirationDate.suffix(2),
                                       Param.expMonth.rawValue:expirationDate.prefix(2),
                                       Param.cvv.rawValue:cvv,
                                       Param.cardId.rawValue:cardId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    /// MARK:- *********************** Provider List (providerList screen-19,17) API ***********************
    func getProviderListAPI(serviceId:Int, priceRange:String,page:Int,name:String,enableLoader:Bool,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            
            if enableLoader{
                self.showHud()
            }
            
            let url =  "\(Constants.APIConstantNames.providerList)"
            print(url)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.getCurrentLocation()
            let loc =  appDelegate.getLocation()
            // let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.latitude.rawValue:loc.coordinate.latitude,
                                       Param.longitude.rawValue:loc.coordinate.longitude,
                                       Param.serviceId.rawValue:serviceId,
                                       Param.priceRange.rawValue:priceRange,
                                       Param.distance.rawValue:sliderValue,
                                       Param.paginationIndex.rawValue:page,
                                       Param.name.rawValue:name] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    /// MARK:- *********************** Provider List (providerList screen-19,17) API ***********************
    func getProviderListWithoutServiceIdAPI(priceRange:String,page:Int,name:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.providerList)"
            print(url)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.getCurrentLocation()
            let loc =  appDelegate.getLocation()
            // let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.latitude.rawValue:loc.coordinate.latitude,
                                       Param.longitude.rawValue:loc.coordinate.longitude,
                                       Param.serviceId.rawValue:"",
                                       Param.priceRange.rawValue:priceRange,
                                       Param.distance.rawValue:sliderValue,
                                       Param.paginationIndex.rawValue:page,
                                       Param.name.rawValue:name] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    /// MARK:- *********************** Card Listing (cardList screen 13) API ***********************
    func getCardListAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.listCard)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Change Notification API (33. changeNotification (changeNotification)) ***********************
    func changeNotificationAPI(status:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.changeNotification)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.status.rawValue:status] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    // MARK:- *********************** Change Notification API (33. changeNotification (changeNotification)) ***********************
    func cancelAppointmentAPI(id:Int,reason:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.cancelAppointment)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.bookingId.rawValue:id,
                                       Param.userType.rawValue:"C",
                                       Param.cancelDesc.rawValue:reason] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    /// MARK:- *********************** Send Image Message API ***********************
    func sendImageMessageAPI(image:UIImage,receiverId:Int, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            let url =  "\(Constants.APIConstantNames.sendMessage)"
            print(url)
            self.showHud()
            let params : Dictionary = [ Param.receiverId.rawValue:receiverId,
                                        Param.senderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                        ] as [String : Any]
            print(params)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                let fileName =  Date().stringDate(format: "ddmmyyyyhhmmss")
                multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName:Param.image.rawValue ,fileName: fileName.appending(".jpg"), mimeType: "image/jpg")
                
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: self.headers()) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseObject { (apiResponse: DataResponse<ModalBase>) in
                        if self.handleSuccessResponse(apiResponse: apiResponse) {
                            print(apiResponse.result.value!)
                            response(apiResponse.result.value!)
                        }
                    }
                case .failure(let error):
                    self.hideHud()
                    print("Error in upload: \(error.localizedDescription)")
                    Progress.instance.displayAlert(userMessage:error.localizedDescription)
                }
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    //gobinder
    /// MARK:- *********************** Message List  API ***********************
    func getMessagesAPI(response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getMessages)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    //gobinder
    /// MARK:- *********************** Message List  API ***********************
    func deleteUserInMessageAPI(connectionId:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.deleteUserInMessages)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.connectionId.rawValue:connectionId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    //gobinder
    /// MARK:- *********************** Message List  API ***********************
    func getOneToOneMessagesListAPI(connectionId:Int,receiverId:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.getOneToOneMessagesList)"
            print(url)
            let params : Dictionary = [Param.senderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.connectionId.rawValue:connectionId,Param.receiverId.rawValue:receiverId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    //gobinder
    // MARK:- *********************** Send Message List  API ***********************
    func sendTextMessage(receiverId:Int,message:String,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.sendMessage)"
            print(url)
            let params : Dictionary = [Param.senderId.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,Param.message.rawValue:message,Param.receiverId.rawValue:receiverId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- ***********************  View Other User Profile API (ServiceProviderProfile)***********************
    func viewOtherUserProfile(providerId:Int,response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            self.showHud()
            let url =  "\(Constants.APIConstantNames.otherUserProfile)"
            print(url)
            let params : Dictionary = [Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.providerId.rawValue:providerId] as [String : Any]
            self.makePOSTRequest(urlAPI: url, paramsAPI: params) { (JSON) in
                response(JSON)
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    
    // MARK:- *********************** Create Profile API ***********************
    func createProfileAPI(frstName:String,lastName:String,dateOfBirth:String,address:String,phoneNo:String,boolImageAdded:Bool, image:UIImage,location:CLLocationCoordinate2D,city:String,state:String, response:@escaping Response) {
        if NetworkReachabilityManager()!.isReachable {
            let url =  "\(Constants.APIConstantNames.createProfile)"
            print(url)
            self.showHud()
            let params : Dictionary = [Param.firstName.rawValue:frstName,
                                       Param.lastName.rawValue:lastName,
                                       Param.dateOfBirth.rawValue:dateOfBirth,
                                       Param.address.rawValue:address,
                                       Param.mobileNumber.rawValue:phoneNo,
                                       Param.user.rawValue:ModalShareInstance.shareInstance.modalUserData.userInfo!.id!,
                                       Param.latitude.rawValue:location.latitude ,
                                       Param.longitude.rawValue :location.longitude,
                                       Param.city.rawValue : city,
                                       Param.state.rawValue : state
                ] as [String : Any]
            print(params)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                if boolImageAdded {
                    let fileName =  Date().stringDate(format: "ddmmyyyyhhmmss")
                    multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName:Param.profileImage.rawValue ,fileName: fileName.appending(".jpg"), mimeType: "image/jpg")
                }
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: self.headers()) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseObject { (apiResponse: DataResponse<ModalBase>) in
                        if self.handleSuccessResponse(apiResponse: apiResponse) {
                           // print(apiResponse.result.value!)
                            response(apiResponse.result.value!)
                        }
                    }
                        .responseJSON { (response) in
                            print(response.result.value!)
                            
                    }
                case .failure(let error):
                    self.hideHud()
                    print("Error in upload: \(error.localizedDescription)")
                    Progress.instance.displayAlert(userMessage:error.localizedDescription)
                }
            }
        } else {
            Progress.instance.displayAlert(userMessage:Validation.call.noInternet)
        }
    }
    
    func makePOSTRequestRawData(urlAPI:String, paramsAPI:Dictionary<String, Any>, response:@escaping Response)  {
        Alamofire.request(self.creatingRequest(strUrl: urlAPI, dictParams: paramsAPI, methodName: HTTPMethod.post.rawValue))
            .responseJSON { (response) in
                print(response.result.value)
                
            }
            .responseObject { (apiResponse: DataResponse<ModalBase>) in
            if self.handleSuccessResponse(apiResponse: apiResponse) {
               // print(apiResponse.result.value!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    response(apiResponse.result.value!)
                }
            }
        }
    }
    
    func makePOSTRequest(urlAPI:String, paramsAPI:Dictionary<String, Any>, response:@escaping Response)  {
        print(paramsAPI)
        Alamofire.request(urlAPI, method: .post, parameters: paramsAPI, encoding: JSONEncoding.default, headers: self.headers())
            .responseJSON { (response) in
                print(response.result.value)
                
            }
            .responseObject { (apiResponse: DataResponse<ModalBase>) in
                if self.handleSuccessResponse(apiResponse: apiResponse) {
                   // print(apiResponse.result.value!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        response(apiResponse.result.value!)
                    }
                }
        }
        
    }
    
    func handleSuccessResponse(apiResponse:DataResponse<ModalBase>) -> Bool {
        self.hideHud()
        if apiResponse.result.isSuccess {
            if apiResponse.response?.statusCode == 200 {
                if apiResponse.result.value?.status == 200 || apiResponse.result.value?.status == 404 {
                    return true
                } else if apiResponse.result.value?.status == 401 {
                    var topVC = UIApplication.shared.keyWindow?.rootViewController
                    while((topVC!.presentedViewController) != nil){
                        topVC = topVC!.presentedViewController
                    }
                    let actionSheetController = UIAlertController (title: "Session Expired", message: (apiResponse.result.value?.message)!, preferredStyle: UIAlertControllerStyle.alert)
                    //Add Save-Action
                    actionSheetController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                        UserDefaults.standard.removeObject(forKey: "USERDETAILS")
                        UserDefaults.standard.synchronize()
                        ModalShareInstance.shareInstance.modalUserData = nil
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.makingRoot("initial")
                    }))
                    topVC?.present(actionSheetController, animated: true, completion: nil)
                }else if apiResponse.result.value?.status == 405 {
                    var topVC = UIApplication.shared.keyWindow?.rootViewController
                    while((topVC!.presentedViewController) != nil){
                        topVC = topVC!.presentedViewController
                    }
                    let actionSheetController = UIAlertController (title: "Update Required", message: (apiResponse.result.value?.message)!, preferredStyle: UIAlertControllerStyle.alert)
                    //Add Save-Action
                    actionSheetController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                        UserDefaults.standard.removeObject(forKey: "USERDETAILS")
                        UserDefaults.standard.synchronize()
                        ModalShareInstance.shareInstance.modalUserData = nil
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.makingRoot("initial")
                        
                        if let url = URL(string: "itms-apps://itunes.apple.com/"),
                            UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.open(url, options: [:]) { (opened) in
                                if(opened){
                                    print("App Store Opened")
                                }
                            }
                        } else {
                            print("Can't Open URL on Simulator")
                        }
                        
                    }))
                    topVC?.present(actionSheetController, animated: true, completion: nil)
                } else {
                    if apiResponse.result.value?.message != nil {
                        Progress.instance.displayAlert(userMessage:(apiResponse.result.value?.message)!)
                    }
                }
            } else {
                Progress.instance.displayAlert(userMessage:(apiResponse.result.value?.message)!)
            }
        } else {
            self.handleFailureResponse(apifailure:apiResponse.result.error!)
        }
       // print(apiResponse)
        return false
    }
    
    func creatingRequest(strUrl:String, dictParams: Dictionary<String, Any>, methodName:String) -> URLRequest {
        var request = URLRequest(url: URL(string: strUrl)!)
        request.httpMethod = methodName
        request.allHTTPHeaderFields = self.headers()
        let data = try! JSONSerialization.data(withJSONObject: dictParams, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }
        if methodName !=  HTTPMethod.get.rawValue {
            request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        }
        return request
    }
    
    func handleFailureResponse(apifailure:Error)  {
        let error : Error = apifailure
        Progress.instance.displayAlert(userMessage:error.localizedDescription)
    }
    
    func showHud() {
        Progress.instance.show()
    }
    
    func hideHud() {
        Progress.instance.hide()
    }
}

extension Date {
    func stringDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
