//
//  DateUtils.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import Foundation

extension Date {
    
    enum FormatType: String {
        case normal = "yyyy-MM-dd HH:mm:ss"
        case short = "yyyy-MM-dd"
    }
    
    func format(_ type:FormatType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        return formatter.string(from: self)
    }
    
 
    
    static func format(_ seconds:TimeInterval, units:[NSCalendar.Unit] = [.minute, .second]) -> String {
        let formatter = DateComponentsFormatter.init()
        formatter.allowedUnits = NSCalendar.Unit(rawValue: units.reduce(into: 0, { (a, b) in
            return a |= b.rawValue
        }))
        // .pad为0:00:00格式
        formatter.zeroFormattingBehavior = .pad
        // .positional 是数字:数字:数字格式
        formatter.unitsStyle = DateComponentsFormatter.UnitsStyle.positional
        return formatter.string(from: seconds) ?? ""
    }
    
    //字符串转Date
    static func getDate(timeString: String, dateFormat: String) -> Date {
         let dateformatter = DateFormatter()
         dateformatter.dateFormat = dateFormat
         let date = dateformatter.date(from: timeString) ?? Date()
         return date
     }

}
