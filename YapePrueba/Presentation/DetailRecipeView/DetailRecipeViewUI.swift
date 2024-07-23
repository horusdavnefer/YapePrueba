//
//  DetailRecipeView.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Resolver
import SkeletonUI
import SwiftUI
import UIKit

struct DetailRecipeViewUI<ViewModelType>: View where ViewModelType: DetailRecipeViewModel {
    @ObservedObject var viewModel: ViewModelType = Resolver.resolve()
    //@Environment(\.openURL) private var openURL
    @Environment(\.presentationMode) var presentationMode

    @ViewBuilder
    var infoView: some View {
        VStack(alignment: .leading) {
            BackButton(presentationMode: presentationMode)
                    .padding()
            
            Text(viewModel.state.yapeRecipe?.title)
                .font(.custom(ConstantsUi.Font.bold, size: 17))
                .foregroundStyle(.black)
                .skeleton(with:  viewModel.state.isLoading,
                          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .capsule)
            
            VStack {
                AsyncImage(url: URL.getUrl(from: viewModel.state.yapeRecipe?.url_image)) { image in
                    image
                        .centerCropped()
                        .cornerRadius(4)
                } placeholder: {
                    AnyView(ActivityIndicator())
                }
                .skeleton(with:  viewModel.state.isLoading,
                          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .capsule)
               
                .frame(maxWidth: .infinity, minHeight: DetailRecipeState.Constants.heightImageVertically) 
                
            }
            
            .cornerRadius(/*@START_MENU_TOKEN@*/4.0/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity)
            
            
           
            Text(viewModel.state.yapeRecipe?.description)
                .font(.custom(ConstantsUi.Font.italic, size: 15))
                .foregroundStyle(.black)
                .skeleton(with:  viewModel.state.isLoading,
                          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .capsule)
           
        }
        Spacer()
    }

    var listsView: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(DetailRecipeState.Constants.titleIngredients)
                .font(.custom(ConstantsUi.Font.black, size: 17))
                .foregroundStyle(.black)
                .skeleton(with:  viewModel.state.isLoading,
                          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .capsule)
            CustomTabView(with: viewModel.state.ingredients!, content: { _, loading, ingredient in
                TabViewItem(text: ingredient?.ingredient, loading: loading) 
            })
            Spacer()
            Text(DetailRecipeState.Constants.titleReceta)
                .font(.custom(ConstantsUi.Font.black, size: 17))
                .foregroundStyle(.black)
                .skeleton(with:  viewModel.state.isLoading,
                          animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .capsule)
            CustomTabView(with: viewModel.state.steps!, content: { _, loading, step in
                TabCountViewItem(text: step?.step, loading: loading)
            })
            Spacer()
            Button("Ir al Restaurante") {
                viewModel.showRouteView(recipe: viewModel.state.yapeRecipe)
            }
            
        }
        .padding(.vertical, 5)
    }
    
    
    
    var body: some View {
        
            ScrollView {
                VStack(alignment: .center) {
                    infoView
                    listsView
                }.padding()
                    .onAppear {
                        viewModel.onAppear()
                    }
                    .onDisappear {
                        viewModel.onDisAppear()
                    }
                
            }
            .background(ConstantsUi.Colors.colorWhiteBackground.edgesIgnoringSafeArea(.all))
            .navigationBarTitle(DetailRecipeState.Constants.title)
        
   
    }
}


