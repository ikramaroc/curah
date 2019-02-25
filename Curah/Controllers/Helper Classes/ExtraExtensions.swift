//
//  Extensions.swift
//  Curah
//
//  Created by Netset on 17/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController
{
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func getDeviceToken() -> String  {
        if (UserDefaults.standard.value(forKey: "device_token") != nil){
            return UserDefaults.standard.value(forKey: "device_token") as? String ?? ""
        }else{
            return ""
        }
        
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        return text.filter {okayChars.contains($0) }
    }
    
    func convertToLocalDateFormatOnlyTime(utcDate:String) -> String
    {
        if utcDate.count == 0
        {
            return ""
        }
        else
        {
            // create dateFormatter with UTC time format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let dt = dateFormatter.date(from: utcDate)
            dateFormatter.timeZone = TimeZone.current
            
            let finalDateStr = dateFormatter.string(from: dt!)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            //  return dateFormatter.date(from: differenceDate!)
            return Date().offsetLong(date: dateFormatter.date(from: finalDateStr)!)
        }
    }
}
extension UIDatePicker {
    func set13YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -13
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -100
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
    
}
extension UILabel {
    func setHTML(html: String) {
        do {
            let at : NSAttributedString = try NSAttributedString(data: html.data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil);
            self.attributedText = at;
        } catch {
            self.text = html;
        }
    }
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.underlineStyle, value:NSUnderlineStyle.styleSingle.rawValue , range: NSRange(location: 0, length: attributedString.length - 1))
            
            attributedText = attributedString
        }
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        
        
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: Constants.AppFont.fontAvenirHeavy, size: 15)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: Constants.AppFont.fontAvenirRoman, size: 14)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func offsetLong(date: Date) -> String {
        if years(from: date)   > 0
        {
            if months(from: date)  < 12
            {
                return months(from: date) > 1 ? "\(months(from: date)) months ago" : "\(months(from: date)) month ago"
            }
            else
            {
                return years(from: date) > 1 ? "\(years(from: date)) years ago" : "\(years(from: date)) year ago"
            }
        }
        if months(from: date)  > 0
        {
            if weeks(from: date)   < 4
            {
                return weeks(from: date) > 1 ? "\(weeks(from: date)) weeks ago" : "\(weeks(from: date)) week ago"
            }
            else
            {
                return months(from: date) > 1 ? "\(months(from: date)) months ago" : "\(months(from: date)) month ago"
            }
        }
        if weeks(from: date)   > 0
        {
            if days(from: date)    < 7
            {
                return days(from: date) > 1 ? "\(days(from: date)) days ago" : "\(days(from: date)) day ago"
            }
            else
            {
                return weeks(from: date) > 1 ? "\(weeks(from: date)) weeks ago" : "\(weeks(from: date)) week ago"
            }
        }
        if days(from: date)    > 0
        {
            if hours(from: date)   < 24
            {
                return hours(from: date) > 1 ? "\(hours(from: date)) hours ago" : "\(hours(from: date)) hour ago"
            }
            else
            {
                return days(from: date) > 1 ? "\(days(from: date)) days ago" : "\(days(from: date)) day ago"
            }
        }
        if hours(from: date)   > 0
        {
            if minutes(from: date) < 59
            {
                return minutes(from: date) > 1 ? "\(minutes(from: date)) minutes ago" : "\(minutes(from: date)) minute ago"
            }
            else
            {
                return hours(from: date) > 1 ? "\(hours(from: date)) hours ago" : "\(hours(from: date)) hour ago"
            }
        }
        if minutes(from: date) > 0
        {
            if seconds(from: date) < 59
            {
                return seconds(from: date) > 1 ? "\(seconds(from: date)) seconds ago" : "\(seconds(from: date)) second ago"
            }
            else
            {
                return minutes(from: date) > 1 ? "\(minutes(from: date)) minutes ago" : "\(minutes(from: date)) minute ago"
            }
        }
        if seconds(from: date) > 0
        {
            return seconds(from: date) > 1 ? "\(seconds(from: date)) seconds ago" : "\(seconds(from: date)) second ago"
        }
        
        return "just now"
    }
    
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   == 1
        {
            return "\(years(from: date)) year"
        }
        else if years(from: date)   > 1
        {
            return "\(years(from: date)) years"
        }
        if months(from: date)  == 1
        {
            return "\(months(from: date)) month"
        }
        else if months(from: date)  > 1
        {
            return "\(months(from: date)) month"
        }
        if weeks(from: date)   == 1
        {
            return "\(weeks(from: date)) week"
        }
        else if weeks(from: date)   > 1
        {
            return "\(weeks(from: date)) weeks"
        }
        if days(from: date)    == 1
        {
            return "\(days(from: date)) day"
        }
        else if days(from: date)    > 1
        {
            return "\(days(from: date)) days"
        }
        if hours(from: date)   == 1
        {
            return "\(hours(from: date)) hour"
        }
        else if hours(from: date)   > 1
        {
            return "\(hours(from: date)) hours"
        }
        if minutes(from: date) == 1
        {
            return "\(minutes(from: date)) minute"
        }
        else if minutes(from: date) > 1
        {
            return "\(minutes(from: date)) minutes"
        }
        return ""
    }
}
extension String {
    func validateUrl () -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }
}
extension UIImageView{
    
    func circular()
    {
        // self.layer.backgroundColor = colour.cgColor
        self.layer.cornerRadius = self.layer.frame.size.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    func roundCornerBorderOnly()
    {
        // self.layer.backgroundColor = colour.cgColor
        self.layer.cornerRadius = self.layer.frame.size.height/2
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.green.cgColor
    }
    func roundCornerWithWhiteBorder()
    {
        self.layer.cornerRadius = self.layer.frame.size.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    
}

