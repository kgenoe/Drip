//
//  UIBorderedButton.swift
//  DripSimpleHydration
//
//  Created by Kyle on 2018-01-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit

class UIBorderedButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = 5
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.0
        layer.masksToBounds = true
    }
}
