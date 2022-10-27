//
//  NSAttributedStringUtils.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import UIKit


extension NSAttributedString {
    
    class func attribute(for number:Int, unit:Unit, prefix:Bool = false, font:UIFont = .systemFont(ofSize: 20, weight: .medium)) -> NSAttributedString {
        let content = prefix ? unit.symbol + " \(number)" : "\(number) " + unit.symbol
        let attr = NSMutableAttributedString(string: content, attributes: [
            .font: font,
        ])
        if let r = content.range(of: unit.symbol) {
            let range = NSRange(r, in: content)
            attr.addAttributes([
                .font: UIFont.systemFont(ofSize: font.pointSize/2),
            ], range: range)
        }
        return attr
    }
    
    //大标题以及副标题
    class func attribute(for title:String, options:[NSAttributedString.Key: Any] = [:], subTitle:String = "", subOptions:[NSAttributedString.Key: Any] = [:]) -> NSAttributedString {
        var attributes = options
        if attributes.count < 1 {
            attributes[.font] = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
        if !attributes.keys.contains(.paragraphStyle) {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 4
            attributes[.paragraphStyle] = style
        }
        let attrStr = NSMutableAttributedString(string: title, attributes: attributes)
        if subTitle.isEmpty {
            return attrStr
        }
        if subOptions.count > 0 {
            attributes.merge(subOptions) { (key1, key2) -> Any in
                return key2
            }
        } else {
            attributes[.font] = UIFont.systemFont(ofSize: 12)
        }
        let subAttrStr = NSAttributedString(string: subTitle, attributes: attributes)
        attrStr.append(subAttrStr)
        return attrStr
    }
    
    class func attribute(for keys:[String], values:[CustomStringConvertible], keyOptinons:[NSAttributedString.Key:Any], valueOptions:[NSAttributedString.Key:Any], split:String = "\n") -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        let options:[NSAttributedString.Key:Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .paragraphStyle: style
        ]
        let leftOptions = keyOptinons.merging(options) { (key1, key2) -> Any in
            return key1
        }
        let rightOptions = valueOptions.merging(options) { (key1, key2) -> Any in
            return key1
        }
        let attrStr = NSMutableAttributedString()
        for (key,value) in zip(keys,values) {
            let keyAttr = NSAttributedString(string: key, attributes: leftOptions)
            let valueAttr = NSAttributedString(string: value.description + split, attributes: rightOptions)
            attrStr.append(keyAttr)
            attrStr.append(valueAttr)
        }
        return attrStr
    }
    
}
