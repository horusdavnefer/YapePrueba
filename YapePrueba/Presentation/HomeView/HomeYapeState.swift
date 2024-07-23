//
//  HomeYapeState.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import Foundation
final class HomeYapeState: ObservableObject {
    
    @Published var yapeRecipes: [RecipeObject] = []
    @Published var searchText:String = ""

    @Published var isLoading: Bool = false
    @Published var cellType: CellType = .horizontal
    @Published var numberSkeletonCellYape: Int = 4
    @Published var selectedTab: Int = 0
    @Published var showError: Bool = false
    @Published var yapeErrorType: YapeErrorType?
    enum Constants {
        static let SubTitleSeeBenefits: String = "Prepara y disfruta"
        static let title = "Antojitos"
    }

}

enum CellType {
    case horizontal
    case vertically
}
