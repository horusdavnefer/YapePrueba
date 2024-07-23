//
//  APIError.swift
//  YapePrueba
//
//  Created by iMac on 16/07/24.
//

import Foundation

struct APIError: Codable {
    var message: String?
    var description: String?

    init(message: String?,
         description: String?) {
        self.message = message
        self.description = description
    }
}
