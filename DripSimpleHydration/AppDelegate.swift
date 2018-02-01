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
    
    // Case: View is still in memory but water has been updated from Today widget. ViewWillAppear won't be called because view is still in memory but label needs updating.
    func applicationWillEnterForeground(_ application: UIApplication) {
        if let main = application.windows.first?.rootViewController as? MainViewController {
            main.refreshTodaysDrinkCount()
        }
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        HealthKitManager.shared.getDietaryWater(on: Date()) { quantity in
            let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
            let unitType = UnitType(rawValue: unitTypeString)!
            let hkUnit = unitType.associatedHKUnit()
            guard let displayValue = quantity?.doubleValue(for: hkUnit).rounded(toPlaces: 1) else { return }
            UserDefaults.shared.set(displayValue, forKey: DefaultsKey.mostRecentWater)
        }
    }

    
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        HKHealthStore().handleAuthorizationForExtension { (success, error) in
            if success { print("Success - handleAuthorizationForExtension") }
            else { print("Error - handleAuthorizationForExtension: \(String(describing: error))")}
        }
    }
}

