//
//  IngredientsObject.swift
//  YapePrueba
//
//  Created by iMac on 19/07/24.
//

import Foundation
struct IngredientsObject: Identifiable {
    var id: String
    var ingredient: String
    init(
        id: String,
        ingredient: String){
            self.id = id
            self.ingredient = ingredient
        }
}
