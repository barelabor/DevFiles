//
//  Defines.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

struct Notifications {
    
    enum Location: String {
        case StatusDenied = "Notifications.Location.StatusDenied"
    }
}

struct Constants {
    
    enum Size: CGFloat {
        case ScreenHeight
        case ScreenWidth
        
        var floatValue: CGFloat {
            switch self {
            case .ScreenHeight: return max(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
            case .ScreenWidth: return min(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
            }
        }
    }
}

struct ShowSegue {
    
    enum ShopList: String {
        case LocationMap = "Show.ShopList.LocationMap"
    }
    
    enum VehicleDetails: String {
        case Search = "Show.VehicleDetails.Search"
    }
    
    enum Search: String {
        case PartsAndLabor = "Show.Search.PartsAndLabor"
    }
    
    enum NeedTire: String {
        case SignUp = "Show.NeedTire.SignUp"
        case Chart = "Show.NeedTire.Chart"
    }
    
    enum PartsAndLabor: String {
        case Results = "Show.PartsAndLabor.Results"
    }
    
    enum Results: String {
        case Settings = "Show.Results.Settings"
    }
    
    enum Settings: String {
        case TermPrivacy = "Show.Settings.TermPrivacy"
    }
    
    enum Experience: String {
        case PositiveNegative = "Show.Experience.PositiveNegative"
    }
    
    enum Camera: String {
        case Preview = "Show.Camera.Preview"
    }
    
    enum Preview: String {
        case Result = "Show.Preview.Result"
    }
    
}

struct PresentSegue {
    
    enum SignUp: String {
        case Login = "Present.SignUp.Login"
    }
}