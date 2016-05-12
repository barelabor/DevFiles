//
//  CarInfo.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import Foundation

class CarInfo {
    
    let year: String!
    let make: String!
    let model: String!
    let engineSize: String!
    
    init(year: String!, make: String!, model: String!, engineSize: String!) {
        self.year = year
        self.make = make
        self.model = model
        self.engineSize = engineSize
    }
}