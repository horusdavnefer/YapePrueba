//
//  CarouselCellView.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import AVKit
import SwiftUI
struct CarouselCellView: View {
    var recipe: RecipeObject?
    var loading: Bool

    init(recipe: RecipeObject?,
         loading: Bool)
    {
        self.recipe = recipe
        self.loading = loading
    }

    private enum Constants {
        static let whiteColorBackground: Color = ConstantsUi.Colors.colorWhiteBackground
        static let whiteColor: Color = ConstantsUi.Colors.colorWhite
    }

    var body: some View {
        ZStack {
            Color.black
            
            AsyncImage(url: URL.getUrl(from: recipe?.url_image)) { image in
                image
                    .resizable()
            } placeholder: {
                AnyView(ActivityIndicator())
            }
            .skeleton(with:  loading,
                      animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .rectangle)
           
            .foregroundColor(ConstantsUi.Colors.colorGrayDark)
            

            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                
                Text(recipe?.title)
                    .font(.custom(ConstantsUi.Font.bold, size: 24))
                    .foregroundColor(Constants.whiteColor)
                    .skeleton(with:  loading,
                          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .rectangle)
    
                Spacer()
                    .frame(height: 30)
            }
            .padding(14)
            .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .center, endPoint: .bottom))
        }
    }
}
