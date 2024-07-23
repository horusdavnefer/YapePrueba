//
//  RouteViewModelType.swift
//  YapePrueba
//
//  Created by iMac on 19/07/24.
//

import Foundation
protocol RouteViewModelType: ObservableObject, Identifiable {
    var state: RouteViewState {get set}
    var routeData: RouteData {get set}
    
    
    func onAppear()
    func onDisAppear()
    
    func isComplete()
    func noComplete()
}
