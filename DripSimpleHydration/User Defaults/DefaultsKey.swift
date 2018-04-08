//
//  DefaultsKey.swift
//  DripSimpleHydration
//
//  Created by Kyle on 2018-01-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation

struct DefaultsKey {
    
    static var unitType: String = "unitType"
    
    static func mainKey(for unitType: UnitType) -> String {
        switch unitType {
        case .Cups: return "mainCupsKey"
        case .Metric: return "mainMetricKey"
        case .Ounces: return "mainOuncesKey"
        }
    }
    
    static func leftKey(for unitType: UnitType) -> String {
        switch unitType {
        case .Cups: return "leftCupsKey"
        case .Metric: return "leftMetricKey"
        case .Ounces: return "leftOuncesKey"
        }
    }
    
    static func rightKey(for unitType: UnitType) -> String {
        switch unitType {
        case .Cups: return "rightCupsKey"
        case .Metric: return "rightMetricKey"
        case .Ounces: return "rightOuncesKey"
        }
    }
    
    static var mostRecentWater: String = "mostRecentWater"
    
    static var mostRecentWaterDate: String = "mostRecentWaterDate"
    
}
