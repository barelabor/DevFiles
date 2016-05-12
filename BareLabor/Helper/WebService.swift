//
//  WebService.swift
//  Bowden
//
//  Created by super on 1/8/16.
//  Copyright © 2016 super. All rights reserved.
//

import UIKit

class WebServiceObject: NSObject {
    
    static let BASE_URL = "http://barelabor.com"
    static let API_PATH = "/barelabor/api"
    
    // delcare URL
    static let getEstimatesURL = "/index.php?method=getEstimates"                  // for GET ESTIMATES
    
    
    // Post Request
    static func postRequest(url: String, requestDict: Dictionary<String, String!>, completionHandler: ((AnyObject?, AnyObject?, NSError?) -> Void)) {
        
        // create request data
        let urlString = "\(BASE_URL)\(API_PATH)\(url)"
        let requestURL = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        //
        var firstOneAdded = false
        var contentBodyAsString = ""
        let contentKeys: Array<String> = Array(requestDict.keys)
        
        for contentKey in contentKeys {
            if (!firstOneAdded) {
                contentBodyAsString += contentKey + "=" + requestDict[contentKey]!
                firstOneAdded = true
            } else {
                contentBodyAsString += "&" + contentKey + "=" + requestDict[contentKey]!
            }
        }
        
        request.HTTPBody = contentBodyAsString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, error -> Void in
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                completionHandler(jsonData, response, error)
            } catch {
            }
        }
        task.resume()
    }
    
    
}
