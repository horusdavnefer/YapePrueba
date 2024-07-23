//
//  UIApplication+Extensions.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = getKeyWindow()?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabBarController = controller as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    class func getKeyWindow() -> UIWindow? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        return keyWindow
    }
}

