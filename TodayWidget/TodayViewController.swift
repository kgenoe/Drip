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
        
        // set global unit type
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(rawValue: unitTypeString)!
        
        // style buttons for unit type & preferences
        let leftSize = UserDefaults.shared.double(forKey: DefaultsKey.leftKey(for: unitType))
        let rightSize = UserDefaults.shared.double(forKey: DefaultsKey.rightKey(for: unitType))
        let mainSize = UserDefaults.shared.double(forKey: DefaultsKey.mainKey(for: unitType))
        leftDrinkButton.setTitle("+\(leftSize) \(unitType.toUnitString())", for: [])
        rightDrinkButton.setTitle("+\(rightSize) \(unitType.toUnitString())", for: [])
        mainDrinkButton.setTitle("+\(mainSize) \(unitType.toUnitString())", for: [])
        
        //self.refreshTodaysDrinkCount()
    }
    
    
    
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("Widget perform update!")
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
            DispatchQueue.main.async {
                let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
                let unitType = UnitType(rawValue: unitTypeString)!
                let hkUnit = unitType.associatedHKUnit()
                if let displayValue = quantity?.doubleValue(for: hkUnit).rounded(toPlaces: 1) {
                    self.drankTodayValueLabel.text = "\(displayValue) \(unitType.toUnitString())"
                } else {
                    self.drankTodayValueLabel.text = "Unlock to view."
                }
            }
        }
    }
    
    
    //MARK: - UI Actions
    @IBAction func leftButtonPressed() {
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(rawValue: unitTypeString)!
        let value = UserDefaults.shared.double(forKey: DefaultsKey.leftKey(for: unitType))
        let quantity = HKQuantity(unit: unitType.associatedHKUnit(), doubleValue: value)
        HealthKitManager.shared.saveDietaryWater(quantity: quantity) {
            self.refreshTodaysDrinkCount()
        }
    }
    
    
    @IBAction func rightButtonPressed() {
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(rawValue: unitTypeString)!
        let value = UserDefaults.shared.double(forKey: DefaultsKey.rightKey(for: unitType))
        let quantity = HKQuantity(unit: unitType.associatedHKUnit(), doubleValue: value)
        HealthKitManager.shared.saveDietaryWater(quantity: quantity) {
            self.refreshTodaysDrinkCount()
        }
    }
    
    @IBAction func mainButtonPressed() {
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(rawValue: unitTypeString)!
        let value = UserDefaults.shared.double(forKey: DefaultsKey.mainKey(for: unitType))
        let quantity = HKQuantity(unit: unitType.associatedHKUnit(), doubleValue: value)
        HealthKitManager.shared.saveDietaryWater(quantity: quantity) {
            self.refreshTodaysDrinkCount()
        }
    }
    
}
