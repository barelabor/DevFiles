//
//  Network.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class Network: NSObject {
    
    class var sharedInstance: Network {
        
        struct Singleton {
            static let instance = Network()
        }
        return Singleton.instance
    }
    
    // Base URL String
    static let baseURLString = "http://barelabor.com/"
    
    // Registration URL String
    static let registrationURLString = baseURLString + "barelabor/api/index.php?method=register"
    
    // Login URL String
    static let loginURLString = baseURLString + "barelabor/api/index.php?method=login"
    
    // Get Make from Year URL String
    static let getMakeURLString = baseURLString + "barelabor/api/index.php?method=getMake"
    
    // Get Model URL String
    static let getModelURLString = baseURLString + "barelabor/api/index.php?method=getModel"
    
    // Get Features URL String
    static let getFeaturesURLString = baseURLString + "barelabor/api/index.php?method=getFeatures"
    
    // Get price by vehicle URL String
    static let getVehiclePrice = baseURLString + "barelabor/api/index.php?method=getPriceByVehicle"
    
    // Get price by size URL String
    static let getSizePrice = baseURLString + "barelabor/api/index.php?method=getPriceBySize"
    
    // SubmitExpirience URL String
    static let submitExperience = baseURLString + "barelabor/api/index.php?method=submitExperience"

	// SubmitEstimate URL String
	static let submitEstimate = baseURLString + "barelabor/api/index.php?method=submitEstimate"
	
    // GetEstimate URL String
    static let getEstimate = baseURLString + "barelabor/api/index.php?method=getEstimates"
    
	// Get neares locations list by user location
    static let getNearestLocations = baseURLString + "barelabor/api/index.php?method=findNearShop"
    
    // Get Repairs
    static let getRepairsURL = baseURLString + "barelabor/api/index.php?method=getRepairs"
    
    // Headers JSON
    static let URLHeaders = ["Content-Type" : "application/json", "Accept" : "application/json"]
    
    
    func get(url: String, parameters: [String: AnyObject]? = nil, completionHandler: (data : AnyObject?) -> ()){
        
        Alamofire.request(.GET, url, parameters: parameters, encoding: .JSON, headers: Network.URLHeaders).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (_, _, result) -> Void in
            
            switch result {
            case .Success(let data):
                completionHandler(data: data)
            case .Failure(_, let error):
                print("Request failed with error: \(error)")
                completionHandler(data: nil)
            }
        }
    }
    
    func post(url: String, parameters: [String: AnyObject]? = nil, completionHandler: (data : AnyObject?) -> ()){
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON, headers: Network.URLHeaders).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (_, _, result) -> Void in
            
            switch result {
            case .Success(let data):
                completionHandler(data: data)
            case .Failure(_, let error):
                print("Request failed with error: \(error)")
                completionHandler(data: nil)
            }
        }
    }
	
	func postMultipartData(multipartData: [String : NSData], url: String, parameters: [String : AnyObject]?, completionHandler: (data : AnyObject?) -> ())
	{
		Alamofire.upload(
			.POST,
			url,
			headers: nil,
			multipartFormData: { (multipartFormData) -> Void in
				for (key, data) in multipartData
				{
					let filename = NSUUID().UUIDString + ".jpg"
					multipartFormData.appendBodyPart(data: data, name: key, fileName: filename, mimeType: "image/jpeg")
				}
				
				if let parameters = parameters
				{
					for (key, parameter) in parameters
					{
						multipartFormData.appendBodyPart(data: "\(parameter)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: key)
					}
				}
			},
			encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold)
			{ (encodingResult) -> Void in
				switch encodingResult
				{
					case .Success(let upload, _, _):
						upload.responseString { (request, response, result) -> Void in
							debugPrint(result)
						}.responseJSON { _, response, result in
							switch result
							{
								case .Success(let data):
									completionHandler(data: data)
								case .Failure(_, _):
									completionHandler(data: nil)
							}
						}
					case .Failure(let encodingError):
						debugPrint(encodingError)
						completionHandler(data: nil)
				}
		}
	}
	
    /**
	
     MAKE REGISTRATION
     
     - parameter username Username
     - parameter password User password
     - parameter email User Email
     - parameter userFullname Full user name
     */
    
    func signUP(userName: String, password: String, email: String, userFullName: String, deviceToken: String, completion: (data:[String:AnyObject]?) -> Void) {
        
        let url = Network.registrationURLString
        let params = ["username":userName,
            "password":password,
            "email": email,
            //"userFullname" : userFullName,
            "device_token" : deviceToken]
        
        post(url, parameters: params) { (data) -> () in
            
            if (nil != data) {
                
                var returnedDictionary:[String : AnyObject] = [:]
                let registrationInfo = data as? [String : AnyObject]
                
                if let status = registrationInfo!["status"] as? String, var item = registrationInfo!["item"] as? [String:AnyObject] {
                    item["status"] = status
                    returnedDictionary = item
                    
                }
                completion(data: returnedDictionary)
            } else {
                completion(data: nil)
            }
        }
    }
    
    func signUP(userName: String, password: String, deviceToken: String, completion: (data:[String:AnyObject]?) -> Void) {
        
        let url = Network.registrationURLString
        let params = ["username":userName,
                      "password":password,
                      "device_token" : deviceToken]
        
        post(url, parameters: params) { (data) -> () in
            
            if (nil != data) {
                
                print("data=%@", data)
                var returnedDictionary:[String : AnyObject] = [:]
                let registrationInfo = data as? [String : AnyObject]
                
                if let status = registrationInfo!["status"] as? String, var item = registrationInfo!["item"] as? [String:AnyObject] {
                    item["status"] = status
                    returnedDictionary = item
                    
                }
                completion(data: returnedDictionary)
            } else {
                completion(data: nil)
            }
        }
    }
    
    /**
     
     LOG IN
     
     - parameter username Username from registration
     - parameter password User password from registration
     */
    
    func logIn(userName: String, password: String, device_token: String, completion: (data:[String:AnyObject]?) -> Void) {
        
        let url = Network.loginURLString
        let params = ["username":userName,
            "password":password,
            "device_token":device_token]
        
        post(url, parameters: params) { (data) -> () in
            
            if (nil != data) {
                var returnedDictionary: [String: AnyObject] = [:]
                let logInInfo = data as? [String : AnyObject]
                
                if let status = logInInfo!["status"] as? String, var item = logInInfo!["item"] as? [String:AnyObject] {
                    item["status"] = status
                    returnedDictionary = item
                }
                completion(data: returnedDictionary)
            } else {
                completion(data: nil)
            }
        }
    }
    
    /**
     
     Get Estimates value
     
     - parameter UserID and EstimateID
     
     */
    
    func getEstimates(userID: String, estimateID: String, completion: (data:[String:AnyObject]?) -> Void) {
        let url = Network.getEstimate
        let params = ["userID":userID,
                      "estimateID":estimateID]
        
        post(url, parameters: params) { (data) -> () in
            
            if (nil != data) {
                var returnedDictionary: [String: AnyObject] = [:]
                let logInInfo = data as? [String : AnyObject]
                print(data)
                if let status = logInInfo!["status"] as? String, var item = logInInfo!["item"] as? [String:AnyObject] {
                    item["status"] = status
                    returnedDictionary = item
                }
                completion(data: returnedDictionary)
            } else {
                completion(data: nil)
            }
        }
    }
    
    /**
     
     GET MAKE
     
     - parameter year From year's make search
     */
    
    func getMakeFromYear(year: String, completion: (data:[String]?) -> Void) {
        
        let url = Network.getMakeURLString
        let params = ["year":year]
        
        post(url, parameters: params) { (data) -> () in
            
            if (nil != data) {
                var returnArray: [String] = []
                
                let makes = data as! NSDictionary
                
                for items in makes["items"] as! [String] {
                    returnArray.append(items)
                }
                completion(data: returnArray)
            } else {
                completion(data: nil)
            }
        }
    }
    
    /**
     GET MODEL
     
     - parameter year From year's make search
     - parameter make Get's make from year
     */
    
    func getModel(year: String, make: String, completion: (data: [String]?) -> Void) {
        
        let url = Network.getModelURLString
        let params = ["year":year,
            "make":make]
        
        post(url, parameters: params) { (data) -> () in
            
            if (nil != data) {
                var returnArray: [String] = []
                
                let models = data as! NSDictionary
                
                for items in models["items"] as! [String] {
                    returnArray.append(items)
                }
                completion(data: returnArray)
            } else {
                completion(data: nil)
            }
        }
    }
    
    /**
     GET FEATURES
     
     - parameter year From year's make search
     - parameter make Get's make from year
     - parameter model Get's model from make
     */
    
    func getFeatures(year: String, make: String, model: String, completion: (data: [String]?) -> Void) {
        
        let url = Network.getFeaturesURLString
        let params = ["year":year,
            "make":make,
            "model":model]
        
        post(url, parameters: params) { (data) -> () in
            
            if (nil != data) {
                var returnArray: [String] = []
                
                let features = data as! NSDictionary
                
                for items in features["items"] as! [String] {
                    returnArray.append(items)
                }
                completion(data: returnArray)
            } else {
                completion(data: nil)
            }
        }
    }
    
    /**
     GET PRICE BY VEHICLE
     
     - parameter year From year's make search
     - parameter make Get's make from year
     - parameter model Get's model from make
     - parameter feature Get's feature from model
     */
    
    func getPriceByVehicle(year: String, make: String, model: String, feature: String, completion: (data: [String]?, ratingArray: NSArray) -> Void) {
        
        let url = Network.getVehiclePrice
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("userID") as! NSString!
        let params = ["year" :year,
            "make":make,
            "model":model,
            "feature":feature,
            "userID": userID]
        
        post(url, parameters: params) { (data) -> () in
            print(data)
            if (nil != data) {
                var returnArray: [String] = []
                let prices = data as! NSDictionary
                let ratingArray	= data!["ratings"] as! NSArray!
                for items in prices["items"] as! [String] {
                    returnArray.append(items)
                }
                completion(data: returnArray, ratingArray: ratingArray)
            } else {
                completion(data: nil, ratingArray: [])
            }
        }
    }
    
    /**
     GET PRICE BY SIZE
     
     - parameter width Width of searched object
     - parameter ratio Ratio of searched object
     - parameter diameter Diameter of searched object
     */
    
    func getPriceBySize(width: String, ratio: String, diameter: String, completion: (data: [String]?, ratingArray: NSArray) -> Void) {
        
        let url = Network.getSizePrice
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("userID") as! NSString!
        let params = ["width":width,
            "ratio":ratio,
            "diameter":diameter,
            "userID": userID]
        
        post(url, parameters: params) { (data) -> () in
            let priceItems = data!["items"] as! NSArray!
            print(data)
            if(priceItems.count != 0) {
                var returnArray: [String] = []
                
                let prices = data as! NSDictionary
                let ratingArray	= data!["ratings"] as! NSArray!
                for items in prices["items"] as! [String] {
                    returnArray.append(items)
                }
                completion(data: returnArray, ratingArray: ratingArray)
            } else {
                print("failed")
                completion(data: nil, ratingArray: [])
            }
        }
    }
    
    /**
     GET Repairs
     */
    
    func getRepairs(year: String, make: String, model: String, engineSize: String, part: String, completion: (lowPrice: String!, averagePrice:String!, highPrice: String!) -> Void) {
        
        let url = Network.getRepairsURL
        let params = ["year":year,
                      "make":make,
                      "model":model,
                      "engineSize": engineSize,
                      "part": part]
        
        post(url, parameters: params) { (data) -> () in
            print(data)
            let status = data!["status"] as! String!
            if status == "OK" && data != nil{
                let intAveragePrice = data!["averagePrice"]! as! Int
                let lowPrice = data!["lowPrice"] as! String!
                let averagePrice = "\(intAveragePrice)"
                let highPrice = data!["highPrice"] as! String!
                completion(lowPrice: lowPrice, averagePrice: averagePrice, highPrice: highPrice)
            }
             
            else {
                completion(lowPrice: "", averagePrice: "", highPrice: "")
            }
        }
    }
    
    /**
    SUBMIT EXPERIENCE
    
    - parameter userID Logged user ID
    - parameter type Can be positive or negative
    - parameter answers User answers
    - parameter name User name
    - parameter email User Email
    - parameter shop_name User shop name
    - parameter comments User comments
    */
    
    func sumbitExperience(userID: String, type: String, answers: String, name: String, email: String, shopName: String, comments: String, completion: (data: [String: AnyObject]?) -> Void) {
        
        let url = Network.submitExperience
        let params = ["userID":userID,
            "type":type,
            "answers":answers,
            "name":name,
            "email":email,
            "shop_name":shopName,
            "comments":comments]
        
        post(url, parameters: params) { (data) -> () in
            if (nil != data) {
                completion(data: data as? [String : AnyObject])
            } else {
                completion(data: nil)
            }
        }
    }
	
	func submitEstimateImage(image: UIImage, completion: (success: Bool) -> ())
	{
		let url = Network.submitEstimate
		if let userID = NSUserDefaults.standardUserDefaults().objectForKey("userID")
		{
			let params = ["userID" : userID]
			let imageData = UIImageJPEGRepresentation(image, 0.8)!
			let multipartData = ["estimateImage" : imageData]
			
			postMultipartData(multipartData, url: url, parameters: params, completionHandler: { (data) -> () in
				if let data = data
				{
					if let status = data["status"] as? String where status == "OK"
					{
                        print(data)
                        //save EstimateID to local storage
                        NSUserDefaults.standardUserDefaults().setValue(data["item"], forKey: "estimateID")
                        
						completion(success: true)
					} else
					{
						completion(success: false)
					}
				} else
				{
					completion(success: false)
				}
			})

		} else
		{
			print("Error: User not logged in")
			completion(success: false)
		}
	}

	/**
     GET NEAREST LOCATIONS BY USER LOCATION
    - parameter latitude User location latitude
    - parameter longitude User location longitude
     */
    
    func getNearestLocationWithLocationLatitude(latitude: Double, locationLongitude longitude: Double, completion: (data: [[String:AnyObject]]?, errorMessage: String?) -> Void) {
        
        let url = Network.getNearestLocations
        let params = ["lat": latitude,
                      "lng": longitude]
        post(url, parameters: params) { (data) -> () in
            
            if (nil != data) {
                var returnArray: [[String:AnyObject]] = []
                
                if let items = data!["items"] as? [[String:AnyObject]] {
                    for items in items {
                        returnArray.append(items)
                    }
                    completion(data: returnArray, errorMessage: nil)
                } else if var status = data!["status"] as? String {
                    status = status.stringByReplacingOccurrencesOfString("_", withString: " ")
                    completion(data: nil, errorMessage: status)
                }
            } else {
                completion(data: nil, errorMessage: "Unknown error")
            }
        }
    }
}