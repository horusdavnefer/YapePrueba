//
//  GetYapeRecipesInteractor.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import Foundation
import Combine

class GetYapeRecipesInteractor: AnyInteractor<Any?, [RecipeObject]> {
    
    let repository: YapePruebaRepositoryType
    
    init(repository: YapePruebaRepositoryType) {
        self.repository = repository
    }
    
    override func execute(params: Any?) -> AnyPublisher<[RecipeObject], Error> {
        return repository.getYapeRecipes()
    }
    
}
