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

extension NSURL
{
    struct ValidationQueue {
        static var queue = NSOperationQueue()
    }
    
    class func validateUrl(urlString: String?, completion:(success: Bool, urlString: String? , error: NSString) -> Void)
    {
        // Description: This function will validate the format of a URL, re-format if necessary, then attempt to make a header request to verify the URL actually exists and responds.
        // Return Value: This function has no return value but uses a closure to send the response to the caller.
        
        var formattedUrlString : String?
        
        // Ignore Nils & Empty Strings
        if (urlString == nil || urlString == "")
        {
            completion(success: false, urlString: nil, error: "Url String was empty")
            return
        }
        
        // Ignore prefixes (including partials)
        let prefixes = ["http://www.", "https://www.", "www."]
        for prefix in prefixes
        {
            if ((prefix.rangeOfString(urlString!, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)) != nil){
                completion(success: false, urlString: nil, error: "Url String was prefix only")
                return
            }
        }
        
        // Ignore URLs with spaces (NOTE - You should use the below method in the caller to remove spaces before attempting to validate a URL)
        // Example:
        // textField.text = textField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        let range = urlString!.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet())
        if let test = range {
            completion(success: false, urlString: nil, error: "Url String cannot contain whitespaces")
            return
        }
        
        // Check that URL already contains required 'http://' or 'https://', prepend if it does not
        formattedUrlString = urlString
        if (!formattedUrlString!.hasPrefix("http://") && !formattedUrlString!.hasPrefix("https://"))
        {
            formattedUrlString = "http://"+urlString!
        }
        
        // Check that an NSURL can actually be created with the formatted string
        if let validatedUrl = NSURL(string: formattedUrlString!)
        {
            // Test that URL actually exists by sending a URL request that returns only the header response
            let request = NSMutableURLRequest(URL: validatedUrl)
            request.HTTPMethod = "HEAD"
            ValidationQueue.queue.cancelAllOperations()
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                let url = request.URL!.absoluteString
                
                // URL failed - No Response
                if (error != nil)
                {
                    completion(success: false, urlString: url, error: "The url: \(url) received no response")
                    return
                }
                
                // URL Responded - Check Status Code
                if let urlResponse = response as? NSHTTPURLResponse
                {
                    if ((urlResponse.statusCode >= 200 && urlResponse.statusCode < 400) || urlResponse.statusCode == 405)// 200-399 = Valid Responses, 405 = Valid Response (Weird Response on some valid URLs)
                    {
                        completion(success: true, urlString: url, error: "The url: \(url) is valid!")
                        return
                    }
                    else // Error
                    {
                        completion(success: false, urlString: url, error: "The url: \(url) received a \(urlResponse.statusCode) response")
                        return
                    }
                }

            }
            task.resume()
        }
    }
}