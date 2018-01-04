//
//  UnitType.swift
//  DripSimpleHydration
//
//  Created by Kyle on 2018-01-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation
import HealthKit

enum UnitType: String {
    case Metric
    case Cups
    case Ounces
    
    
    static func fromInt(_ value: Int) -> UnitType? {
        if value == 0 { return .Cups }
        else if value == 1 { return .Metric }
        else if value == 2 { return .Ounces }
        else { return nil }
    }
    
    func toInt() -> Int {
        switch self {
        case .Cups: return 0
        case .Metric: return 1
        case .Ounces: return 2
        }
    }
    
    func toTitleString() -> String {
        switch self {
        case .Cups: return "Cups"
        case .Metric: return "Milliliters"
        case .Ounces: return "Ounces"
        }
    }
    
    func toUnitString() -> String {
        switch self {
        case .Cups: return "Cups"
        case .Metric: return "ml"
        case .Ounces: return "fl oz"
        }
    }
    
    func associatedHKUnit() -> HKUnit {
        switch self {
        case .Cups: return HKUnit.cupUS()
        case .Metric: return HKUnit.literUnit(with: .milli)
        case .Ounces: return HKUnit.fluidOunceUS()
        }
    }
}
