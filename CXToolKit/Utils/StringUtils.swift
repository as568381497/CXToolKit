//
//  StringUtils.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import CommonCrypto
import UIKit

extension String {
    
    func priceStr(_ count:Int = 1) -> String {
        return (Double(self) ?? 0).priceStr(count)
    }
    
    
    //去掉所有空格
    var removeAllSapce: String {
           return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    //md5 加密
    var md5: String {
           let str = self.cString(using: String.Encoding.utf8)
           let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
           let digestLen = Int(CC_MD5_DIGEST_LENGTH)
           let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
           CC_MD5(str!, strLen, result)

           let hash = NSMutableString()

           for i in 0..<digestLen {
               hash.appendFormat("%02x", result[i])
           }

           result.deallocate()
           return hash as String
       }
    
    
    //字符串转字典
    func toDictionary() -> [String : Any] {
        
        var result = [String : Any]()
        guard !self.isEmpty else { return result }
        
        guard let dataSelf = self.data(using: .utf8) else {
            return result
        }
        
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf,
                           options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
    
    }
}
