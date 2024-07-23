//
//  DetailRecipeViewModel.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Combine
import Resolver
import Foundation
import SystemConfiguration
import SwiftUI

final class DetailRecipeViewModel: BaseViewModel {
    @Published var state = DetailRecipeState()
    
    //@Injected var getCodeForBenefitInteractor: AnyInteractor<Int, CodeObject>
    
    struct InputDependencies {
        let detailRecipeData: DetailRecipeData
        let ownView: YapeViewType
    }
    private var subscribers: Set<AnyCancellable> = []
    
    private let dependencies: InputDependencies
    var detailRecipeData: DetailRecipeData
    
    init(dependencies: InputDependencies) {
        self.dependencies = dependencies
        detailRecipeData = dependencies.detailRecipeData
        super.init()
        setupYapeRecipe()
    }
    
    private func setupYapeRecipe() {
        state.yapeRecipe = detailRecipeData.recipe
        state.ingredients = getIngredients()
        state.steps = getSteps()
        state.isLoading = false
        objectWillChange.send()
    }
    
    private func getIngredients() -> [IngredientsObject]{
        var ingredients:[IngredientsObject] = (state.yapeRecipe?.ingredients.map {IngredientsObject(id: "0" , ingredient: $0)})!
        return ingredients
        
    }
    private func getSteps() -> [StepStepObject]{
        var steps:[StepStepObject] = (state.yapeRecipe?.recipe.map {StepStepObject(id: "0" , step: $0)})!
        return steps
        
    }
    func isConnectedToNetwork() -> Bool {

        /*var status:Bool = false

        let url = NSURL(string: "https://google.com")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 5.0

        var response:URLResponse?

        do {
            let _ = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData?
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }

        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }*/
        return true
    }
    
    
   
    
}

extension DetailRecipeViewModel: DetailRecipeViewModelType {
    func showRouteView(recipe: RecipeObject?) {
        if isConnectedToNetwork() {
            Resolver.registerPresentationRouteViewDependencies(recipe: recipe!)
            dependencies.ownView.showRouteView()
        } else {
            state.yapeErrorType = .noInternetConnection
            showConnectivityError()
        }
    }
    
    
    
    func onAppear() {}
    
    func onDisAppear() {}
    
    func isComplete() {}
    
    func noComplete() {}
    
}

