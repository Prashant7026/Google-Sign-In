//
//  NavigateToRootVC.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 20/05/25.
//

import Foundation
import UIKit

class NavigateToRootVC {
    static func navigateToRootViewController(_ rootViewController: UIViewController) {
        let navVC = UINavigationController(rootViewController: rootViewController)
        
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate, let window = sceneDelegate.window {
            window.rootViewController = navVC
            window.makeKeyAndVisible()
            
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3
            window.layer.add(transition, forKey: kCATransition)
        }
    }
}
