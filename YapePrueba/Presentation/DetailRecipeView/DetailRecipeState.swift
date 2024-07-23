//
//  DetailRecipeState.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Foundation
final class DetailRecipeState: ObservableObject {
    
    @Published var yapeRecipe: RecipeObject?
    @Published var ingredients: [IngredientsObject]?
    @Published var steps: [StepStepObject]?
    @Published var isLoading: Bool = false
    @Published var cellType: CellType = .horizontal
    @Published var numberSkeletonCellYape: Int = 4
    @Published var selectedTab: Int = 0
    @Published var showError: Bool = false
    @Published var url_image_back = ""
    @Published var yapeErrorType: YapeErrorType?
    enum Constants {
        static let SubTitleSeeBenefits: String = "Prepara y disfruta"
        static let title = "Antojitos"
        static let titleIngredients = "Ingredientes"
        static let titleReceta = "Paso a Paso"
        static let heightImageVertically : CGFloat = 250
        static let heightImageBack : CGFloat = 30
        static let widthImageBack : CGFloat = 30
    }

}
