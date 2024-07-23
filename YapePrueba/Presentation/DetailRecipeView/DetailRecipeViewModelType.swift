//
//  DetailRecipeViewModelType.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Foundation
protocol DetailRecipeViewModelType: ObservableObject, Identifiable {
    var state: DetailRecipeState {get set}
    var detailRecipeData: DetailRecipeData {get set}
    
    func showRouteView(recipe: RecipeObject?)
    
    func onAppear()
    func onDisAppear()
    
    func isComplete()
    func noComplete()
}
