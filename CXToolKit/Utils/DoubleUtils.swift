//
//  DoubleUtils.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import Foundation

extension Double {
    
    var distanceStr:String {
        /*
         https://baike.baidu.com/item/%E7%9A%AE%E7%B1%B3/1615132?fr=aladdin
         有时在原子物理学中称为微微米（micromicron）
         换算关系
         1 皮米=10^（-15）千米
         1 皮米=10^（-12）米
         0.001 皮米 = 1 飞米
         1 000 皮米 = 1 纳米(nm)
         1 000 000 皮米 = 1 微米(μm)
         1 000 000 000 皮米 = 1 毫米(mm)
         1 000 000 000 000 皮米 =1 米(m)
         1 000 000 000 000 000 皮米 =1 千米(km)
         */
        var distance = Measurement(value: self, unit: UnitLength.meters)
        if self > 1609 {
            distance.convert(to: UnitLength.miles)
        }
        return String(format: "%.1f ", distance.value) + "英里"
    }
    
    func priceStr(_ count:Int = 1) -> String {
        let decimal = NSNumber(value: self * Double(count))
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.positivePrefix = "£"
        formatter.negativePrefix = "£"
        return formatter.string(from: decimal) ?? "0"
    }
    
}
