//
//  RecipeCellView.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import SkeletonUI
import SwiftUI

struct RecipeCellView: View {
    var recipe: RecipeObject?
    var loading: Bool
    var cellType: CellType

    init(recipe: RecipeObject?,
         loading: Bool,
         cellType: CellType) {
        self.recipe = recipe
        self.loading = loading
        self.cellType = cellType
    }

    var body: some View {
        switch cellType {
        case .vertically:
            RecipeCellViewVertical(
                recipe: recipe,
                loading: loading)
        case .horizontal:
            RecipeCellViewHorizontal(
                recipe: recipe,
                loading: loading)
        }
    }
}

