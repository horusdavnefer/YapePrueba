//
//  HomeViewContract.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import Foundation
protocol YapeViewModelType: ObservableObject {
    var state: HomeYapeState { get set }
    func onAppear()
    func onDisAppear()
    func showYapeDetailView(recipe: RecipeObject?)
    func getRecipebyString(_ query: String)
    func changeTypeList(_ type: CellType)
}

protocol YapeViewType {
    func showRecipeDetailView()
    func showRouteView()
}
