//
//  DataConstants.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import Foundation
struct DataConstants {
    enum APIClient {
        static let contentType = "Content-Type"
    }
    
    enum InnerConstants {
        static let applicationJson = "application/json"
    }
    
    struct YapePruebaService {
        static let recipes = "recipes"

    }
    
    struct DateFormats {
        static let YYYYMMddHHMMSS = "yyyy-MM-dd HH:mm:ss"
        static let ddMMYYYY = "MM/dd/yyyy"
    }
}
