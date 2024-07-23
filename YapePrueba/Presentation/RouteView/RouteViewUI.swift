//
//  RouteView.swift
//  YapePrueba
//
//  Created by iMac on 19/07/24.
//
import SwiftUI
import TomTomSDKMapDisplay
import TomTomSDKNavigationUI
import Resolver

struct RouteViewUI<ViewModelType>: View where ViewModelType: RouteViewModel {
    
    @ObservedObject var viewModel: ViewModelType = Resolver.resolve()
    
    @ObservedObject var navigationController: NavigationController
    @Environment(\.presentationMode) var presentationMode
    
   
    @State private var isLoading = false
    //-74.1125988951491
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .topLeading) {
                Content(navigationController: navigationController,endCoord: viewModel.state.getlocatation())
                if let navigationViewModel = navigationController.navigationViewModel {
                    TomTomSDKNavigationUI.NavigationView(
                        navigationViewModel,
                        action: viewModel.handleNavigationAction
                    )
                }
                VStack {
                    HStack {
                        BackButton(presentationMode: presentationMode)
                        Text(viewModel.state.yapeRecipe?.title)
                            .font(.custom(ConstantsUi.Font.bold, size: 20))
                            .foregroundStyle(.black)
                            .skeleton(with:  viewModel.state.isLoading,
                                      animation: .pulse(duration: 0.2, delay: 0.1, speed: 1, autoreverses: true), shape: .capsule)
                       
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                    
                    if isLoading {
                        LoadingView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                    }
                    
                }
            }
            
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Cargando...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
}



