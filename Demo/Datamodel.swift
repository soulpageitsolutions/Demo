//
//  Datamodel.swift
//  Demo
//
//  Created by Soulpage Machintosh 1 on 27/11/18.
//  Copyright © 2018 Soulpage Machintosh 1. All rights reserved.
//

import Foundation
import SwiftyJSON
struct Datamodel {
    
    var title = String()
    var body = String()
    var sigs = String()
    var url  = String()
    var name = String()

    public mutating func fromJsonToString(result: JSON) {
            title = result["title"].stringValue
            body = result["body"].stringValue
            sigs = result["signatureCount"].stringValue
            url = result["url"].stringValue
    }
}
