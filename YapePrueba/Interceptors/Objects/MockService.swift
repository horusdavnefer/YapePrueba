//
//  MockService.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Foundation
struct MockService: Identifiable {
    var id: ObjectIdentifier
    
    var data:[RecipeObject]
    init(
        id: ObjectIdentifier,
        data: [RecipeObject]){
            self.data = data
            self.id = id
        }
}
