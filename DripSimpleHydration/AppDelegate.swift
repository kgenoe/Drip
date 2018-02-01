//
//  AppDelegate.swift
//  DripSimpleHydration
//
//  Created by Kyle on 2018-01-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        InitialDefaults.setIfRequired()
        
        return true
    }

    
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        print("applicationShouldRequestHealthAuthorization")
        HKHealthStore().handleAuthorizationForExtension { (success, error) in
            if success { print("Success - handleAuthorizationForExtension") }
            else { print("Error - handleAuthorizationForExtension: \(String(describing: error))")}
        }
    }
}

