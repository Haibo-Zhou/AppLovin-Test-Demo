//
//  AppDelegate.swift
//  AppLovin Test Demo
//
//  Created by HaiboZhou on 2021/8/27.
//

import AppLovinSDK
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Please make sure to set the mediation provider value to "max" to ensure proper functionality
        ALSdk.shared()!.mediationProvider = "max"
        
        ALSdk.shared()!.userIdentifier = "Haibo_Zhou"
        
        ALSdk.shared()!.initializeSdk { (configuration: ALSdkConfiguration) in
            // Start loading ads
        }
        
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

