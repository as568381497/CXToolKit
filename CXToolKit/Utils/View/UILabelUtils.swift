//
//  UILabelUtils.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import UIKit

extension UILabel {
    
    //根据文字获取高度
    func labelHeght() -> CGFloat {
        
        let dic = [NSAttributedString.Key.font : font]
        let size = CGSize(width: self.frame.width, height: 0)
        let rect = text!.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: dic as [NSAttributedString.Key : Any], context: nil)
        return CGFloat(ceilf(Float(rect.size.height)))
        
    }
    
    
    //根据文字获取高度
    func labelHeght(width:CGFloat) -> CGFloat {
        
        let dic = [NSAttributedString.Key.font : font]
        let size = CGSize(width: width, height: 0)
        let rect = text!.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: dic as [NSAttributedString.Key : Any], context: nil)
        return CGFloat(ceilf(Float(rect.size.height)))
        
    }
    
}
