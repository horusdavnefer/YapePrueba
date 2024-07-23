//
//  LauncherViewController.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import Foundation
import SwiftUI
class LauncherViewController: UIViewController {
    var yapePruebaRepository: YapePruebaRepository?
    let swiftUIController = UIHostingController(rootView: HomeViewUI<HomeViewModel>())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            let vc = swiftUIController
            vc.modalPresentationStyle = .fullScreen
            if #available(iOS 13.0, *) {
                vc.overrideUserInterfaceStyle = .light
            }
            present(swiftUIController, animated: true, completion: nil)

        }
    }


}
