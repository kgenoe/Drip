//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Kyle on 2018-01-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import NotificationCenter
import HealthKit

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var drankTodayValueLabel: UILabel!
    
    @IBOutlet weak var mainDrinkButton: UIBorderedButton!
    
    @IBOutlet weak var leftDrinkButton: UIBorderedButton!
    
    @IBOutlet weak var rightDrinkButton: UIBorderedButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        // request authroizaiton for extension
        HealthKitManager.shared.requestAuthorization({ (finished, error) in
            print("something")
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set unit type
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(string: unitTypeString)!
        
        // style buttons for unit type & preferences
        let leftSize = UserDefaults.shared.double(forKey: DefaultsKey.leftKey(for: unitType))
        let rightSize = UserDefaults.shared.double(forKey: DefaultsKey.rightKey(for: unitType))
        let mainSize = UserDefaults.shared.double(forKey: DefaultsKey.mainKey(for: unitType))
        leftDrinkButton.setTitle("+\(leftSize) \(unitType.toUnitString())", for: [])
        rightDrinkButton.setTitle("+\(rightSize) \(unitType.toUnitString())", for: [])
        mainDrinkButton.setTitle("+\(mainSize) \(unitType.toUnitString())", for: [])
    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        refreshTodaysDrinkCount()
        completionHandler(NCUpdateResult.noData)
    }
    
    // Set min/max display sizes
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0.0, height: 165.0)
        } else if activeDisplayMode == .compact {
            preferredContentSize = CGSize(width: 0.0, height: 110.0)
        }
    }
    
    
    
    func refreshTodaysDrinkCount() {
        HealthKitManager.shared.getDietaryWater(on: Date()) { quantity in
            let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
            let unitType = UnitType(rawValue: unitTypeString)!
            let hkUnit = unitType.associatedHKUnit()
            let displayValue = quantity?.doubleValue(for: hkUnit).rounded(toPlaces: 1) ?? self.mostRecentWater
            DispatchQueue.main.async {
                self.drankTodayValueLabel.text = "\(displayValue) \(unitType.toUnitString())"
            }
            
            // reset most recent water
            self.setMostRecentWater(newValue: displayValue)
        }
    }
    
    
    
    //MARK: - UI Actions
    @IBAction func leftButtonPressed() {
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(string: unitTypeString)!
        let value = UserDefaults.shared.double(forKey: DefaultsKey.leftKey(for: unitType))
        addValueToMostRecentWater(valueToAdd: value)
        let quantity = HKQuantity(unit: unitType.associatedHKUnit(), doubleValue: value)
        HealthKitManager.shared.saveDietaryWater(quantity: quantity) {
            self.refreshTodaysDrinkCount()
        }
    }
    
    
    @IBAction func rightButtonPressed() {
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(string: unitTypeString)!
        let value = UserDefaults.shared.double(forKey: DefaultsKey.rightKey(for: unitType))
        addValueToMostRecentWater(valueToAdd: value)
        let quantity = HKQuantity(unit: unitType.associatedHKUnit(), doubleValue: value)
        HealthKitManager.shared.saveDietaryWater(quantity: quantity) {
            self.refreshTodaysDrinkCount()
        }
    }
    
    @IBAction func mainButtonPressed() {
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(string: unitTypeString)!
        let value = UserDefaults.shared.double(forKey: DefaultsKey.mainKey(for: unitType))
        addValueToMostRecentWater(valueToAdd: value)
        let quantity = HKQuantity(unit: unitType.associatedHKUnit(), doubleValue: value)
        HealthKitManager.shared.saveDietaryWater(quantity: quantity) {
            self.refreshTodaysDrinkCount()
        }
    }
    
    
    
    //MARK: - Most Recent Water
    
    /// The most recent water value saved to UserDefaults. Used as a fallback for when HealthKit is inaccessible.
    var mostRecentWater: Double {
        // If mostRecentWater is from today, return it
        if let saveDate = UserDefaults.shared.value(forKey: DefaultsKey.mostRecentWaterDate) as? Date,
            Calendar.current.isDateInToday(saveDate) {
            return UserDefaults.shared.double(forKey: DefaultsKey.mostRecentWater)
        } // Otherwise, return 0
        else {
            return 0
        }
    }
    
    // Adds valueToAdd to the current mostRecentWater and updates the vale in UserDefaults
    private func addValueToMostRecentWater(valueToAdd: Double) {
        let current = UserDefaults.shared.double(forKey: DefaultsKey.mostRecentWater)
        let updatedMostRecentWater = current+valueToAdd
        UserDefaults.shared.set(updatedMostRecentWater, forKey: DefaultsKey.mostRecentWater)
        UserDefaults.shared.set(Date(), forKey: DefaultsKey.mostRecentWaterDate)
    }
    
    // Replaces current mostRecentWater in UserDefaults with the given newValue
    private func setMostRecentWater(newValue: Double) {
        UserDefaults.shared.set(newValue, forKey: DefaultsKey.mostRecentWater)
        UserDefaults.shared.set(Date(), forKey: DefaultsKey.mostRecentWaterDate)
    }
}


