//
//  BaseViewModelProtocol.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import Foundation


protocol BaseViewModelProtocol {
    
    var view: BaseView? {get set}
    
    func bind(withView view: BaseView)
    func unBind()
    func viewAppear()
    func viewDidAppear()
    func getInitialState()
}
 
