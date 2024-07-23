//
//  HomeViewUI.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Resolver
import SkeletonUI
import SwiftUI

struct HomeViewUI<ViewModelType>: View where ViewModelType: YapeViewModelType & YapeErrorProtocol {
    
    @ObservedObject var viewModel: ViewModelType = Resolver.resolve()
    
    @ViewBuilder
    var searchview: some View {
        VStack(alignment: .leading) {
            NavigationStack {
                ConstantsUi.Colors.colorWhiteBackground.edgesIgnoringSafeArea(.all)
            }
            .searchable(text: $viewModel.state.searchText)
            .onChange(of: viewModel.state.searchText) { value in
                if !value.isEmpty {
                    viewModel.getRecipebyString(viewModel.state.searchText)
                }
            }
            .onSubmit(of: .search) {
                //viewModel.getRecipebyString(viewModel.state.searchText)
            }
            .scrollContentBackground(.hidden)
            
        }
        .frame(width: 380, height: 100,alignment: .topLeading)
        
    }
    
    @ViewBuilder
    var galleryView: some View {
        VStack(alignment: .leading) {
            CarouselView(with: viewModel.state.yapeRecipes, quantity: viewModel.state.numberSkeletonCellYape) { _, loading, yapeRecipes in
                CarouselCellView(recipe: yapeRecipes, loading: loading)
            }
        }
        .padding(.top, 0.0)
        .frame(width: 380, height: 380,alignment: .topLeading)
        .scaledToFit()
        .scaledToFill()
        
    }
    
    
    
    @ViewBuilder
    var SeeYourBenefitsView: some View {
        HStack() {
            Text(HomeYapeState.Constants.SubTitleSeeBenefits)
                .font(.custom(ConstantsUi.Font.medium, size: 16))
                .foregroundColor(ConstantsUi.Colors.colorGrayDark)
                .fixedSize(horizontal: false, vertical: true)
                .skeleton(with:  viewModel.state.isLoading,
                  animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .rectangle)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack() {
                ButtonSelectedView(loading: viewModel.state.isLoading, cellType: .vertically, cellTypeSelected: viewModel.state.cellType, imageDefault: ConstantsUi.Images.iconList, imageSelected: ConstantsUi.Images.iconListSelected) { cellType in
                    viewModel.changeTypeList(cellType) 
                }
                ButtonSelectedView(loading: viewModel.state.isLoading, cellType: .horizontal, cellTypeSelected: viewModel.state.cellType, imageDefault: ConstantsUi.Images.iconCube, imageSelected: ConstantsUi.Images.iconCubeSelected) { cellType in
                    viewModel.changeTypeList(cellType)
                }
            }.frame(alignment: .trailing)
            
            
        }
    }
    
    @ViewBuilder
    var RecipeView: some View {
        VStack {
            SkeletonForEachWithIndex(with: viewModel.state.yapeRecipes, quantity: viewModel.state.numberSkeletonCellYape, cellType: viewModel.state.cellType) { _, loading, recipe, cellType in
                Button {
                    viewModel.showYapeDetailView(recipe: recipe)
                } label: {
                    RecipeCellView(
                        recipe: recipe,
                        loading: loading,
                        cellType: cellType)
                }.frame(alignment: .trailing)
            }
        }
    }
    
    var body: some View {
        
            ScrollView {
                searchview
                if ((viewModel.state.yapeRecipes.count ) > 0){
                    galleryView
                }
                VStack {
                    SeeYourBenefitsView
                    RecipeView
                }
                .padding(.horizontal, 20)

            }
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisAppear()
            }
            .background(ConstantsUi.Colors.colorWhiteBackground.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $viewModel.state.showError) {
                YapeErrorView(yapeErrorTyoe: viewModel.state.yapeErrorType, yapeErrorProtocol: viewModel)
            }
            .navigationBarTitle(Text(HomeYapeState.Constants.title))
            .frame(alignment: .topLeading)
            
        }
    }
    
