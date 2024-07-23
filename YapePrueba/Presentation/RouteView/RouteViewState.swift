//
//  RouteViewState.swift
//  YapePrueba
//
//  Created by iMac on 19/07/24.
//

import Foundation
import CoreLocation
final class RouteViewState: ObservableObject {
    
    @Published var yapeRecipe: RecipeObject?
    @Published var isLoading: Bool = false
    @Published var yapeErrorType: YapeErrorType?
    enum Constants {
        static let SubTitleSeeBenefits: String = "Prepara y disfruta"
        static let title = "Antojitos"
        static let titleIngredients = "Ingredientes"
        static let titleReceta = "Paso a Paso"
        static let heightImageVertically : CGFloat = 250
        static let heightImageBack : CGFloat = 30
        static let widthImageBack : CGFloat = 30
    }
    
    func getlocatation() -> CLLocationCoordinate2D{
        var location : CLLocationCoordinate2D = CLLocationCoordinate2D()
        location.latitude = Double(yapeRecipe!.location.split(separator: ",")[0]) ?? 4.513552684352647
        location.longitude = Double(yapeRecipe!.location.split(separator: ",")[1]) ?? -74.11260527159118
        return location
    }

}
