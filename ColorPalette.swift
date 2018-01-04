//
//  ColorPalette.swift
//  DripSimpleHydration
//
//  Created by Kyle on 2018-01-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import UIKit


// Manages the colours used in this application, storing them in standard hexidecimal form. Provides functionality to convert enum values into UIColors for use in the application.
enum ColorPalette: Int {
    case blue      = 0x546CF6
    
    
    /// Converts a ColorPalette enum value into a UIColor, using *rbg*
    /// - Returns: A UIColor, calculated from an ColorPalette enum value, using *rbg*
    func color() -> UIColor {
        return rgb(
            red:   (rawValue >> 16) & 0xff,
            green: (rawValue >> 8)  & 0xff,
            blue:  rawValue         & 0xff
        )
    }
    
    func cgColor() -> CGColor {
        return color().cgColor
    }
    
    /// Converts Integer RBG values into a UIColor
    /// - Parameter red: Value for red, between 0 and 255
    /// - Parameter green: Value for green, between 0 and 255
    /// - Parameter blue: Value for blue, between 0 and 255
    /// - Returns: A UIColor calculated from the RBG values
    private func rgb(red: Int, green: Int, blue: Int) -> UIColor {
        assert(red   >= 0 && red   <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue  >= 0 && blue  <= 255, "Invalid blue component")
        
        return UIColor(
            red:   CGFloat(red)   / 255.0,
            green: CGFloat(green) / 255.0,
            blue:  CGFloat(blue)  / 255.0,
            alpha: 1.0
        )
    }
}

