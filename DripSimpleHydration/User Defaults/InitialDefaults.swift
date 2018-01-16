//
//  InitialDefaults.swift
//  DripSimpleHydration
//
//  Created by Kyle on 2018-01-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

struct InitialDefaults {
    
    static func setIfRequired() {
        
        let launchedBefore = UserDefaults.shared.bool(forKey: "launchedBefore")
        
        // only set the initial defaults once
        if !launchedBefore  {
            UserDefaults.shared.set(true, forKey: "launchedBefore")
            
            // set default values
            let defaultUnitType = UnitType.Cups
            UserDefaults.shared.set(defaultUnitType.rawValue, forKey: DefaultsKey.unitType)
            
            UserDefaults.shared.set(0.5, forKey: DefaultsKey.leftKey(for: .Cups))
            UserDefaults.shared.set(2.0, forKey: DefaultsKey.rightKey(for: .Cups))
            UserDefaults.shared.set(1.0, forKey: DefaultsKey.mainKey(for: .Cups))
            
            UserDefaults.shared.set(150, forKey: DefaultsKey.leftKey(for: .Metric))
            UserDefaults.shared.set(500, forKey: DefaultsKey.rightKey(for: .Metric))
            UserDefaults.shared.set(350, forKey: DefaultsKey.mainKey(for: .Metric))
            
            UserDefaults.shared.set(8.0, forKey: DefaultsKey.leftKey(for: .Ounces))
            UserDefaults.shared.set(16.0, forKey: DefaultsKey.rightKey(for: .Ounces))
            UserDefaults.shared.set(12.0, forKey: DefaultsKey.mainKey(for: .Ounces))
        }
    }
}
