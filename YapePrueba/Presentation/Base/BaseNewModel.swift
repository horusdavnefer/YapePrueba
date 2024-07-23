//
//  BaseNewModel.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import Foundation


class BaseViewModel: NSObject, BaseViewModelProtocol, ErrorHandlerProtocol {
    
    
    var view: BaseView?
    weak var errorHandler: ErrorHandlerProtocol?
    
    var loading: Bool = false {
        didSet {
            if self.loading {
            } else {}
        }
    }
    
    func bind(withView view: BaseView) {
        self.view = view
        self.errorHandler = view
    }
    
    func unBind() {
        self.view = nil
        self.errorHandler = nil
    }
    
    func viewAppear() {}
    
    func viewDidAppear() {}
    
    func getInitialState() {}
    
    func showConnectivityError() {}
    
    func hideConnectivityError() {}
}
