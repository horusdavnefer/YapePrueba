//
//  RecipeCellViewVertical.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import SkeletonUI
import SwiftUI

struct RecipeCellViewVertical: View {
    var recipe: RecipeObject?
    var loading: Bool

    private enum Constants {
        static let heightImageVertically: CGFloat = 250
        static let widthtImageVertically: CGFloat = 370
        static let heightTextHorizontally: CGFloat = 30
        static let grayLightColor: Color = ConstantsUi.Colors.colorGrayLight
        static let grayDarkColor: Color = ConstantsUi.Colors.colorGrayDark
    }

    init(recipe: RecipeObject?,
         loading: Bool) {
        self.recipe = recipe
        self.loading = loading
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack {
                AsyncImage(url: URL.getUrl(from: recipe?.url_image)) { image in
                    image
                        .centerCropped()
                } placeholder: {
                    AnyView(ActivityIndicator())
                }
                .skeleton(with:  loading,
                      animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .rectangle)
                .foregroundColor(ConstantsUi.Colors.colorGrayDark)
                .cornerRadius(4)
                .frame(maxWidth: .infinity, idealHeight: Constants.heightImageVertically)
            }
            .foregroundColor(ConstantsUi.Colors.colorGrayDark)
            VStack(alignment: .leading, spacing: 4) {
                
                
                Text(recipe?.title)
                    .font(.custom(ConstantsUi.Font.bold, size: 16))
                    .foregroundColor(Constants.grayDarkColor)
                    .lineLimit(2)
                    .skeleton(with:  loading,
                          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .rectangle)
                    .multilineTextAlignment(.leading)
                
                Text(recipe?.description)
                    .font(.custom(ConstantsUi.Font.regular, size: 16))
                    .foregroundColor(Constants.grayDarkColor)
                    .lineLimit(2)
                    .frame(height: Constants.heightTextHorizontally)
                    .skeleton(with:  loading,
                          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .rectangle)
                    .multilineTextAlignment(.leading)
            }.cornerRadius(10.0,corners: [.topLeft,.topRight])
        }
        .cornerRadius(4)
    }
}

