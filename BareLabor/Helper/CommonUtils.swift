//
//  CommonUtils.swift
//  For all swift projects
//
//  Created by super on 01/08/2016.
//  Copyright © 2016 super. All rights reserved.
//

import UIKit
import MBProgressHUD

class CommonUtils: NSObject {
    
    static var progressView : MBProgressHUD = MBProgressHUD.init()

    // show alert view
    static func showAlert(title: String, message: String) {

        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        rootVC?.presentViewController(ac, animated: true){}
    }
    
    // Email Validator
    static func isValidEmail(email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(email)
        
        return result
    }
    // convert string to date
    static func stringToDate(dateStr: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let s = dateFormatter.dateFromString(dateStr)
        return s!
    }
    
    // show progress view
    static func showProgress(view : UIView, label : String) {
        progressView = MBProgressHUD.showHUDAddedTo(view, animated: true)
        progressView.labelText = label
    }

    // hide progress view
    static func hideProgress(){
        progressView.removeFromSuperview()
        progressView.hide(true)
    }

    //compare two days and return string
    
    static func compareDate(fromDate: NSDate, toDate: NSDate) -> String {
        var difference = 0
        if Int(fromDate.year) == Int(toDate.year) {  // if year is same
            if Int(fromDate.month) == Int(toDate.month) {  // if month is same
                if Int(fromDate.date) == Int(toDate.date) {  // if date is same
                    if Int(fromDate.hour) == Int(toDate.hour) {  // if hour is same
                        if Int(fromDate.minute) == Int(toDate.minute) {  // if minute is same
                            return "RIGHT NOW"
                        }
                        else{
                            difference = Int(fromDate.minute)! - Int(toDate.minute)!
                            return "\(difference) MIN AGO"
                        }
                    }
                    else{
                        difference = Int(fromDate.hour)! - Int(toDate.hour)!
                        return "\(difference) HOUR AGO"
                    }
                }
                else{
                    difference = Int(fromDate.date)! - Int(toDate.date)!
                    return "\(difference) DAY AGO"
                }
            }
            else{
                difference = Int(fromDate.month)! - Int(toDate.month)!
                return "\(difference) MONTH AGO"
            }
        }
        else{
            difference = Int(fromDate.year)! - Int(toDate.year)!
            return "\(difference) YEAR AGO"
        }
        
    }
    // compare two days for bigger
    static func isBigger(fromDate: NSDate, toDate: NSDate) -> Bool {
        if Int(fromDate.year) == Int(toDate.year) {
            if Int(fromDate.monthNum) == Int(toDate.monthNum) {
                if Int(fromDate.date) == Int(toDate.date) {
                    if Int(fromDate.hourAMPM) == Int(toDate.hourAMPM) {
                        if Int(fromDate.minute) == Int(toDate.minute) {
                            return false
                        } else if Int(fromDate.minute) > Int(toDate.minute) {
                            return false
                        } else {
                            return true
                        }
                    } else if Int(fromDate.hourAMPM) > Int(toDate.hourAMPM) {
                        return false
                    } else {
                        return true
                    }
                } else if Int(fromDate.date) > Int(toDate.date) {
                    return false
                } else {
                    return true
                }
            } else if Int(fromDate.monthNum) > Int(toDate.monthNum) {
                return false
            } else {
                return true
            }
        } else if Int(fromDate.year) > Int(toDate.year) {
            return false
        } else {
            return true
        }
    }
    
    // compare two days for equal or bigger
    static func isEqualBigger(fromDate: NSDate, toDate: NSDate) -> Bool {
        if Int(fromDate.year) == Int(toDate.year) {
            if Int(fromDate.monthNum) == Int(toDate.monthNum) {
                if Int(fromDate.date) == Int(toDate.date) {
                    if Int(fromDate.hourAMPM) == Int(toDate.hourAMPM) {
                        if Int(fromDate.minute) == Int(toDate.minute) {
                            return true
                        } else if Int(fromDate.minute) > Int(toDate.minute) {
                            return false
                        } else {
                            return true
                        }
                    } else if Int(fromDate.hourAMPM) > Int(toDate.hourAMPM) {
                        return false
                    } else {
                        return true
                    }
                } else if Int(fromDate.date) > Int(toDate.date) {
                    return false
                } else {
                    return true
                }
            } else if Int(fromDate.monthNum) > Int(toDate.monthNum) {
                return false
            } else {
                return true
            }
        } else if Int(fromDate.year) > Int(toDate.year) {
            return false
        } else {
            return true
        }
    }
    
    static func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if cString.characters.count != 6 {
            return UIColor.grayColor()
        }
        
        var rgbValue : UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}



// for custom font
extension UILabel {
    // regular
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.rangeOfString("Bold") == nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    
    // bold
    var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.rangeOfString("Bold") != nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
}

// for get date
extension NSDate {
    // year
    var year: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYY"
        return dateFormatter.stringFromDate(self)
    }
    
    // week day
    var weekDay: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.stringFromDate(self)
    }
    
    // month
    var month: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.stringFromDate(self)
    }
    
    // month - Number
    var monthNum: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M"
        return dateFormatter.stringFromDate(self)
    }
    
    // week day
    var date: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(self)
    }
    
    // hour
    var hour: String {
        get {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH"
            
            if self.AMPM == "PM" {
                return String(stringInterpolationSegment: Int(dateFormatter.stringFromDate(self))! - 12)
            } else {
                return dateFormatter.stringFromDate(self)
            }
        }
    }
    
    var hourAMPM: String {
        get {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH"
            
            return dateFormatter.stringFromDate(self)
        }
    }
    
    // week
    var minute: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.stringFromDate(self)
    }
    
    // AM & PM
    var AMPM: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "a"
        return dateFormatter.stringFromDate(self)
    }
}


extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
            }
        }).resume()
    }
}