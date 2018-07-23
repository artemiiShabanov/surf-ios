//
//  AppDelegate.swift
//  MarvelGuide
//
//  Created by Artemii Shabanov on 16.07.2018.
//  Copyright © 2018 Artemii Shabanov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barStyle = .blackOpaque
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor = UIColor(named: "marvel-red")
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.prefersLargeTitles = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor(named: "marvel-red")
        
        let navigationController = UINavigationController()
        let mainViewController = MainViewController()
        navigationController.setViewControllers([mainViewController], animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }


}

