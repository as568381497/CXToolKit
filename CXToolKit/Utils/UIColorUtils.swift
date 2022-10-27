//
//  UIColorUtils.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/25.
//

import UIKit

extension UIColor {
    
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        } else if hexString.hasPrefix("0x") {
            scanner.scanLocation = 2
        }
        let includeAlpha = (hexString.count - scanner.scanLocation > 6) ? true : false
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let a = (includeAlpha ? Int(color >> 24) : mask ) & mask
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        let alpha = CGFloat(a) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // UIColor -> Hex String
    var hexString: String? {
        return hexString(includeAlpha: false)
    }
    
    func hexString(includeAlpha:Bool) -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        let multiplier = CGFloat(255.999999)
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        if !includeAlpha {
            return String(format: "#%02lX%02lX%02lX", Int(red * multiplier), Int(green * multiplier), Int(blue * multiplier))
        } else {
            return String(format: "#%02lX%02lX%02lX%02lX",Int(red * multiplier), Int(green * multiplier), Int(blue * multiplier), Int(alpha * multiplier))
        }
    }
    
}
