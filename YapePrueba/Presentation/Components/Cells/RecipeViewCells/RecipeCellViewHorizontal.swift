//
//  RecipeCellViewHorizontal.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import SkeletonUI
import SwiftUI

struct RecipeCellViewHorizontal: View {
    var recipe: RecipeObject?
    var loading: Bool

    

    init(recipe: RecipeObject?,
         loading: Bool) {
        self.recipe = recipe
        self.loading = loading
    }

    private enum Constants {
        static let heightImageHorizontally: CGFloat = 250
        static let heightTextHorizontally: CGFloat = 20
        static let grayLightColor: Color = ConstantsUi.Colors.colorGrayLight
        static let grayDarkColor: Color = ConstantsUi.Colors.colorGrayDark
        static let grayShadowColor: Color = ConstantsUi.Colors.colorShadowLight
    }

    var body: some View {
        HStack(alignment: .center){
            VStack(alignment: .leading) {
            GeometryReader { geo in
                HStack {
                    AsyncImage(url: URL.getUrl(from: recipe?.url_image)) { image in
                        image
                            .centerCropped()
                    } placeholder: {
                        AnyView(ActivityIndicator())
                    }
                    .skeleton(with:  loading,
                          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .rectangle)
                    .foregroundColor(ConstantsUi.Colors.colorGrayDark)
                    .frame(maxWidth: .infinity, idealHeight: Constants.heightImageHorizontally, alignment: .top)
                }
                .frame(width: geo.size.width  ,height: geo.size.width , alignment: .top)
                .cornerRadius(10.0,corners: [.topLeft,.topRight])
                .foregroundColor(ConstantsUi.Colors.colorGrayDark)
                .background(ConstantsUi.Colors.colorWhiteBackground.edgesIgnoringSafeArea(.all))
                .scaledToFill()
                
            }
            VStack(alignment: .leading) {
                
                Text(recipe?.title)
                    .font(.custom(ConstantsUi.Font.bold, size: 16))
                    .foregroundColor(Constants.grayDarkColor)
                    .skeleton(with:  loading,
                          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .rectangle)
                    .multilineTextAlignment(.leading)
                
                Text(recipe?.description)
                    .font(.custom(ConstantsUi.Font.regular, size: 16))
                    .foregroundColor(Constants.grayLightColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .skeleton(with:  loading,
                          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .rectangle)
                    .frame(height: Constants.heightTextHorizontally, alignment: .topLeading)
                    .multilineTextAlignment(.leading)
            }
            .padding(.all, 12.0)
            .frame(width: 165.0, alignment: .topLeading)
            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
        }.frame(height: 300.0, alignment: .topLeading)
            .padding(.bottom,20)
            .cornerRadius(10.0,corners: [.topLeft,.topRight])
        }
        .frame(width: 165.0)
        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.white/*@END_MENU_TOKEN@*/)
        .cornerRadius(10.0)
        .shadow(color:Constants.grayShadowColor, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

