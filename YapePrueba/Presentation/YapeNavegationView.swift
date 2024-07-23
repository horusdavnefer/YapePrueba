//
//  YapeNavegationView.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import SwiftUI 
import Foundation
import UIKit
import TomTomSDKNavigationUI

class YapeNavegationView: YapeViewType {
    func showRecipeDetailView() {
        let hostingController = UIHostingController(rootView: DetailRecipeViewUI<DetailRecipeViewModel>())
        let vc = hostingController
        vc.modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            vc.overrideUserInterfaceStyle = .light
        }
        UIApplication.topViewController()?.present(vc, animated: true,completion: nil)
        //UIApplication.topViewController()?.navigationController?.present(vc, animated: true)
    }
    
    func showRouteView() {
        
        let navigationController = NavigationController()
        
      

        let contentView = RouteViewUI(navigationController: navigationController)
        let hostingController = UIHostingController(rootView: contentView)
        // Configurar para que se presente en pantalla completa
        hostingController.modalPresentationStyle = .fullScreen
        // Presentar el ContentView
        UIApplication.topViewController()?.present(hostingController, animated: true) {
            //navigationController.startFreeDriving()
        }
        
    }
     
}
