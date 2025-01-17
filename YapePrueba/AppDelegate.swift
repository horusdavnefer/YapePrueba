//
//  AppDelegate.swift
//  YapePrueba
//
//  Created by iMac on 15/07/24.
//

import UIKit
import Combine
import Resolver
import Foundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var mercadoPruebaRepository: YapePruebaRepositoryType?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Resolver.registerYapePruebaModuleDependencies(with: "https://demo9190459.mockable.io/")
        mercadoPruebaRepository = Resolver.resolve(YapePruebaRepositoryType.self)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

