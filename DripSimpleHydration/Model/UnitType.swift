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
    
    init?(string: String) {
        switch string {
        case "Metric": self = .Metric
        case "Cups": self = .Cups
        case "Ounces": self = .Ounces
        default: return nil
        }
    }
    
    init?(int: Int) {
        switch int {
        case 0: self = .Cups
        case 1: self = .Metric
        case 2: self = .Ounces
        default: return nil
        }
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
