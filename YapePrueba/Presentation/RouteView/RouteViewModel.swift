//
//  RouteViewModel.swift
//  YapePrueba
//
//  Created by iMac on 19/07/24.
//

import Combine
import Resolver
import Foundation
import SystemConfiguration
import SwiftUI
import TomTomSDKNavigationUI

final class RouteViewModel: BaseViewModel {
    @Published var state = RouteViewState()
    let navigationController = NavigationController()
    
    
    struct InputDependencies {
        let routeData: RouteData
    }
    private var subscribers: Set<AnyCancellable> = []
    
    private let dependencies: InputDependencies
    var routeData: RouteData
    
    init(dependencies: InputDependencies) {
        self.dependencies = dependencies
        routeData = dependencies.routeData
        super.init()
        setupDetailYape()
    }
    
    private func setupDetailYape() {
        state.yapeRecipe = routeData.recipe
        TomTomServices.register()
        objectWillChange.send()
    }
    func handleNavigationAction(_ action: TomTomSDKNavigationUI.NavigationView.Action) {
        navigationController.onNavigationViewAction = action
    }
    
    
    
   
    
}

extension RouteViewModel: RouteViewModelType {
    
    
    
    func onAppear() {}
    
    func onDisAppear() {}
    
    func isComplete() {}
    
    func noComplete() {}
    
}

