//
//  ApiMockService.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Foundation

struct ApiMockService: Codable {
    var data:[ApiRecipeObject]
    init(
        data: [ApiRecipeObject]){
            self.data = data
        }
}

