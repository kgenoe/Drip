//
//  SettingsViewController.swift
//  DripSimpleHydration
//
//  Created by Kyle on 2018-01-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit
import YXWaveView
import StoreKit

class SettingsViewController: UIViewController {
    
    
    //MARK: - Properties
    
    fileprivate var waveView: YXWaveView?
    
    @IBOutlet weak var waveContainer: UIView!
    
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mainTextField: UITextField!
    
    @IBOutlet weak var leftTextField: UITextField!
    
    @IBOutlet weak var rightTextField: UITextField!
    
    @IBOutlet weak var donationTextView: UITextView!
    
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(rawValue: unitTypeString)!
        
        // set the selected segment of unitSegmentedControl
        let index = unitType.toInt()
        unitSegmentedControl.selectedSegmentIndex = index
        
        // set text field initial values
        self.refreshTextFields()
        
        // tap background to hide keyboard
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(backgroundPressed))
        self.view.addGestureRecognizer(backgroundTap)
        
        
        var attributes = [NSAttributedStringKey: Any]()
        attributes[.font] = UIFont(name: "Avenir Book", size: 17.0)
        attributes[.foregroundColor] = UIColor.white
        let donationString = NSMutableAttributedString(string: "If you like Drip, consider donating to fund further development.", attributes: attributes)
        let underlineRange = NSRange(location: 27, length: 8)
        donationString.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: underlineRange)
        donationTextView.attributedText = donationString
        
        let donationTap = UITapGestureRecognizer(target: self, action: #selector(donationTextViewTapped))
        donationTextView.addGestureRecognizer(donationTap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // start wave animation
        waveView = YXWaveView(frame: waveContainer.bounds,
                              color: ColorPalette.blue.color())
        waveView?.waveHeight = 10
        waveContainer.addSubview(waveView!)
        waveView?.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        waveView?.stop()
        waveView = nil
    }

    
    func refreshTextFields() {
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(rawValue: unitTypeString)!
        let leftSize = UserDefaults.shared.double(forKey: DefaultsKey.leftKey(for: unitType))
        let rightSize = UserDefaults.shared.double(forKey: DefaultsKey.rightKey(for: unitType))
        let mainSize = UserDefaults.shared.double(forKey: DefaultsKey.mainKey(for: unitType))
        leftTextField.text = "\(leftSize)"
        rightTextField.text = "\(rightSize)"
        mainTextField.text = "\(mainSize)"
    }
    
    
    
    //MARK: - UI Actions
    
    @objc func backgroundPressed() {
        leftTextField.resignFirstResponder()
        rightTextField.resignFirstResponder()
        mainTextField.resignFirstResponder()
    }
    
    @IBAction func backPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unitsDidChange(_ sender: UISegmentedControl) {
        guard let newUnitType = UnitType.fromInt(sender.selectedSegmentIndex) else {
            return
        }
        
        UserDefaults.shared.set(newUnitType.rawValue, forKey: DefaultsKey.unitType)
        self.refreshTextFields()
    }
    
    @IBAction func mainValueUpdated(_ sender: UITextField) {
        guard let text = sender.text, let value = Double(text) else {
            return
        }
        
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(rawValue: unitTypeString)!
        UserDefaults.shared.set(value, forKey: DefaultsKey.mainKey(for: unitType))
    }
    
    @IBAction func leftValueUpdated(_ sender: UITextField) {
        guard let text = sender.text, let value = Double(text) else {
            return
        }
        
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(rawValue: unitTypeString)!
        UserDefaults.shared.set(value, forKey: DefaultsKey.leftKey(for: unitType))
    }
    
    
    @IBAction func rightValueUpdated(_ sender: UITextField) {
        guard let text = sender.text, let value = Double(text) else {
            return
        }
        
        let unitTypeString = UserDefaults.shared.string(forKey: DefaultsKey.unitType)!
        let unitType = UnitType(rawValue: unitTypeString)!
        UserDefaults.shared.set(value, forKey: DefaultsKey.rightKey(for: unitType))
    }
    
    @objc func donationTextViewTapped() {
        let vc = DonationsViewController.instantiate()
        present(vc, animated: true, completion: nil)
    }
}



//MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



extension SettingsViewController: UITextViewDelegate {
    
}
