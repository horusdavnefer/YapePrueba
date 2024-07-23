//
//  APIResponse.swift
//  YapePrueba
//
//  Created by iMac on 16/07/24.
//

import Foundation

struct APIResponse<T : Codable> : Codable {
    let data: [ApiRecipeObject]
    let responseError: APIError?
}
