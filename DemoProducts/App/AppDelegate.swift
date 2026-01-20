//
//  AppDelegate.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let diContainer = AppDIContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: diContainer.makeProductListViewController())
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
