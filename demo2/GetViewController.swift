//
//  GetViewController.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 18/05/25.
//

import Foundation

import UIKit

final class GetViewController {
    static let shared = GetViewController()
    private init() {}

    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController

        if let nav = controller as? UINavigationController {
            return topViewController(controller: nav.visibleViewController)
        } else if let tab = controller as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(controller: selected)
        } else if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }

        return controller
    }
}
