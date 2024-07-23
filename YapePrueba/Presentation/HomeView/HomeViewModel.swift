//
//  HomeViewModel.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import Combine
import Resolver
import SystemConfiguration

class HomeViewModel:BaseViewModel {
    
    @Injected var getYapeRecipesInteractor: AnyInteractor<Any?, [RecipeObject]>
    @Published var state = HomeYapeState()
    
    private var subscribers: Set<AnyCancellable> = []
    private let dependencies: InputDependencies
    private var recipeObjects: [RecipeObject] = []
    
    struct InputDependencies {
        let ownView: YapeViewType
    }
    
    init(dependencies: InputDependencies) {
        self.dependencies = dependencies
        super.init()
        errorHandler = self
        getYapeRecipes()
    }
    
    
    func getYapeRecipes() {
        getYapeRecipesInteractor.execute(params: nil)
            .sink { [weak self] completion in
                guard case .failure(let error) = completion else { return }
                debugPrint("getYapebyString error", error)
                self?.state.yapeErrorType = .error400
                self?.state.isLoading = false
                self?.showConnectivityError()
            } receiveValue: { [weak self] recipes in
                self?.bindRecipes(with: recipes)
                debugPrint("getYapebyString success", recipes)
            }
            .store(in: &subscribers)
    }
    
    func bindRecipes(with recipeObjects: [RecipeObject]) {
        self.recipeObjects = recipeObjects
        state.yapeRecipes = recipeObjects
        state.isLoading = false
        if recipeObjects.isEmpty {
            state.yapeErrorType = .emptyView
            state.numberSkeletonCellYape = 0
            showConnectivityError()
            return
        }
        objectWillChange.send()
    }
    
    func getRecipebyString(_ query: String) {
        if (query.isEmpty) {
            state.yapeRecipes = self.recipeObjects
        } else {
            state.yapeRecipes = state.yapeRecipes.filter{ $0.title.contains(query)  } //|| $0.ingredients.contains(query)
        }
        objectWillChange.send()
    }
    
    func showYapeRecipeDetailView(recipe: RecipeObject?) {
        if isConnectedToNetwork() {
            Resolver.registerPresentationDetailProductViewDependencies(recipe: recipe!)
            dependencies.ownView.showRecipeDetailView()
        } else {
            state.yapeErrorType = .noInternetConnection
            showConnectivityError()
        }
        
    }
    
    func changeTypeList(_ type: CellType) {
        state.cellType = type
        objectWillChange.send()
    }
    
    override func showConnectivityError() {
        state.showError = true
        objectWillChange.send()
    }
    override func hideConnectivityError() {
        state.showError = false
        objectWillChange.send()
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

extension HomeViewModel: YapeViewModelType {
    func showYapeDetailView(recipe: RecipeObject?) {
        if isConnectedToNetwork() {
            Resolver.registerPresentationDetailProductViewDependencies(recipe: recipe!)
            dependencies.ownView.showRecipeDetailView()
        } else {
            state.yapeErrorType = .noInternetConnection
            showConnectivityError()
        }
    }
    
    func onAppear() {
        if isConnectedToNetwork() {
            getYapeRecipes()
        } else {
            state.yapeErrorType = .noInternetConnection
            showConnectivityError()
        }
    }
    
    func onDisAppear() {
        loading = false
    }
    
    
    
    
    func inComplete() {
        if isConnectedToNetwork() {
            
        } else {
            state.yapeErrorType = .noInternetConnection
            showConnectivityError()
        }
    }
    
    func noComplete() {
        loading = false
    }
}

extension HomeViewModel: YapeErrorProtocol {
    func closeAction() {
        hideConnectivityError()
    }
    
    func tryAgain() {
        hideConnectivityError()
        onAppear()
    }
    
    func logOut() {
        
    }
    
}

