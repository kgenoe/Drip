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
    
    @IBOutlet weak var buttonContainerView: UIView!
    
    @IBOutlet weak var mainDrinkButton: UIBorderedButton!
    
    @IBOutlet weak var leftDrinkButton: UIBorderedButton!
    
    @IBOutlet weak var rightDrinkButton: UIBorderedButton!


    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // request authroizaiton
        HealthKitManager.shared.requestAuthorization({ (finished, error) in
        })
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // start wave animation
        waveView = YXWaveView(frame: waveContainer.bounds,
                              color: UIColor(named: "DripBlue")!)
        waveView?.waveHeight = 10
        waveContainer.addSubview(waveView!)
        waveView?.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        waveView?.stop()
        waveView = nil
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let areaHeight = buttonContainerView.frame.height
        let areaWidth = buttonContainerView.frame.width
        
        let availableButtonHeight = areaHeight-(25*3)
        let buttonHeight = availableButtonHeight/2
        
        let mainButtonWidth = areaWidth-50
        let otherButtonWidth = (areaWidth-75)/2
        
        mainDrinkButton.frame = CGRect(x: 25, y: 25, width: mainButtonWidth, height: buttonHeight)
        leftDrinkButton.frame = CGRect(x: 25, y: 50+buttonHeight, width: otherButtonWidth, height: buttonHeight)
        rightDrinkButton.frame = CGRect(x: 50+otherButtonWidth, y: 50+buttonHeight, width: otherButtonWidth, height: buttonHeight)
    }
    
    
    
    func refreshTodaysDrinkCount() {
        HealthKitManager.shared.getDietaryWater(on: Date()) { quantity in
            DispatchQueue.main.async {
                let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
                let unitType = UnitType(rawValue: unitTypeString)!
                let hkUnit = unitType.associatedHKUnit()
                let displayValue = quantity?.doubleValue(for: hkUnit).rounded(toPlaces: 1) ?? 0.0
                self.drankTodayValueLabel.text = "\(displayValue) \(unitType.toUnitString())"
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
