//
//  MainViewController.swift
//  DripSimpleHydration
//
//  Created by Kyle on 2018-01-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import HealthKit
import YXWaveView

class MainViewController: UIViewController {

    
    //MARK: - Properties
    
    fileprivate var waveView: YXWaveView?
    
    @IBOutlet weak var waveContainer: UIView!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var drankTodayTitleLabel: UILabel!
    
    @IBOutlet weak var drankTodayValueLabel: UILabel!
    
    @IBOutlet weak var mainDrinkButton: UIBorderedButton!
    
    @IBOutlet weak var leftDrinkButton: UIBorderedButton!
    
    @IBOutlet weak var rightDrinkButton: UIBorderedButton!


    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // request authroizaiton
        HealthKitManager.shared.requestAuthorization({ (finished, error) in
        })
        
        // start wave animation
        waveView = YXWaveView(frame: waveContainer.bounds,
                              color: ColorPalette.blue.color())
        waveView?.waveHeight = 10
        waveContainer.addSubview(waveView!)
        waveView?.start()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        self.refreshTodaysDrinkCount()
    }
    
    
    
    func refreshTodaysDrinkCount() {
        HealthKitManager.shared.getDietaryWater(on: Date()) { quantity in
            DispatchQueue.main.async {
                let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
                let unitType = UnitType(rawValue: unitTypeString)!
                let hkUnit = unitType.associatedHKUnit()
                let displayValue = quantity.doubleValue(for: hkUnit)
                self.drankTodayValueLabel.text = "\(displayValue.rounded(toPlaces: 1)) \(unitType.toUnitString())"
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
