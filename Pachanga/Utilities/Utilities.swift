//
//  Utilities.swift
//  Pachanga
//
//  Created by Javier Alaves on 9/8/23.
//

import Foundation
import UIKit

final class Utilities {
    
    static let shared = Utilities()
    private init() { }
    
    
    // topViewController function to return our top UIViewController, needed for sign in with Google
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController // this error is fine, can disregard
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}
