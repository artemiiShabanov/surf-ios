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

    fileprivate func initNavigationController() {
        // Override point for customization after application launch.
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barStyle = .blackOpaque
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor = UIColor(named: "marvel-red")
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.prefersLargeTitles = true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        initNavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor(named: "marvel-red")
        
        let navigationController = UINavigationController()
        let mainViewController = MainViewController()
        navigationController.setViewControllers([mainViewController], animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let id = Int(url.host!) {
            
            initNavigationController()
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.backgroundColor = UIColor(named: "marvel-red")
            
            let navigationController = UINavigationController()
            let mainViewController = MainViewController()
            navigationController.setViewControllers([mainViewController], animated: false)
            
            MarvelAPI.downloadCharacterBy(id: id) { character in
                if let characterNotNil = character {
                    mainViewController.initialCharacter = characterNotNil
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                } else {
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                    //show alert if invalid character id is in the url
                    let alert = UIAlertController(title: "Invalid id", message: "Url has an invalid reference to a character. You can try to find him yourself", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    mainViewController.present(alert, animated: true, completion: nil)
                }
            }
            return true
        } else {
            return false
        }
        
    }

}

