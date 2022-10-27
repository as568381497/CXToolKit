//
//  AppMessageCenter.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import UIKit
import CoreTelephony
import AdSupport
import SwiftKeychainWrapper

//用户信息
class  AppMessageCenter {
    
    /// 便捷
    static let shared = AppMessageCenter()
    
    
    //读取用户UUID
    func readUserUUID() -> String{
        
        //读取
        var userUUIDString = String(KeychainWrapper.standard.string(forKey: "userUUID") ?? "")
        
        
        if userUUIDString == ""{
            let userUUID = UUID().uuidString
            KeychainWrapper.standard.set(userUUID, forKey: "userUUID")
            userUUIDString = userUUID
        }
        
        return userUUIDString
        
    }
    
    //加密UUID
    func encryptionUUID() -> String {
        
        let userUUID = readUserUUID()
        
        let UUIDstring = userUUID.prefix(3) + userUUID.suffix(5)
        
        return String(UUIDstring)
    }
    
    //检查本机SIM卡
    func checkSIM() -> Bool {
        
        let CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        
        
        if #available(iOS 12.0, *) {
            
            if CTTelephonyNetworkInfo.serviceCurrentRadioAccessTechnology?.count == 0 {
                return false
            }else{
                return true
            }
            
            
        }else{
            
            if CTTelephonyNetworkInfo.subscriberCellularProvider?.mobileCountryCode?.count == 0 {
                
                return false
                
            }else{
                
                return true
                
            }
            
        }
        
    }
    
    //获取手机信息
    func getUserIphoneSetting() -> String {
        
        return self.deviceModelName() + ";" + UIDevice.current.systemName + UIDevice.current.systemVersion + ";" + String.init(format:"%.2f", UIScreen.main.bounds.size.width) + "*" + String.init(format:"%.2f", UIScreen.main.bounds.size.height) + ";" + self.fileSizeToString(fileSize: self.zz_getTotalDiskSize()) + ";" + self.fileSizeToString(fileSize: self.zz_getAvailableDiskSize()) + ";"
    }
    
    //获取手机版本
    func deviceModelName() -> String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        switch platform {
        //MARK: iPod
        case "iPod1,1":
            return "iPod Touch 1"
        case "iPod2,1":
            return "iPod Touch 2"
        case "iPod3,1":
            return "iPod Touch 3"
        case "iPod4,1":
            return "iPod Touch 4"
        case "iPod5,1":
            return "iPod Touch (5 Gen)"
        case "iPod7,1":
            return "iPod Touch 6"
        //MARK: iPhone
        case "iPhone5,1":
            return "iPhone 5"
        case "iPhone5,2":
            return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":
            return "iPhone 5c (GSM)"
        case "iPhone5,4":
            return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":
            return "iPhone 5s (GSM)"
        case "iPhone6,2":
            return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":
            return "iPhone 6"
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"
        case "iPhone8,4":
            return "iPhone SE"
        case "iPhone9,1":
            return "国行、日版、港行 iPhone 7"
        case "iPhone9,2":
            return "港行、国行 iPhone 7 Plus"
        case "iPhone9,3":
            return "美版、台版 iPhone 7"
        case "iPhone9,4":
            return "美版、台版 iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2","iPhone10,5":
            return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":
            return "iPhone X"
        case "iPhone11,8":
            return "iPhone XR"
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone11,6":
            return "iPhone XS Max"
        case "iPhone11,4":
            return "iPhone XS Max (China)"
        case "iPhone12,1":
            return "iPhone 11"
        case "iPhone12,3":
            return "iPhone 11 Pro"
        case "iPhone12,5":
            return "iPhone 11 Pro Max"
        case "iPhone13,1":
            return "iPhone 12 mini"
        case "iPhone13,2":
            return "iPhone 12"
        case "iPhone13,3":
            return "iPhone 12 Pro"
        case "iPhone13,4":
            return "iPhone 12 Pro Max"
        case "iPhone14,4":
            return "iPhone 13 mini"
        case "iPhone14,5":
            return "iPhone 13"
        case "iPhone14,2":
            return "iPhone 13 Pro"
        case "iPhone14,3":
            return "iPhone 13 Pro Max"
        //MARK: iPad
        case "iPad1,1":
            return "iPad"
        case "iPad1,2":
            return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":
            return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":
            return "iPad Air 2"
        case "iPad6,3", "iPad6,4":
            return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":
            return "iPad Pro 12.9"
        //MARK: AppleTV
        case "AppleTV2,1":
            return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":
            return "Apple TV 3"
        case "AppleTV5,3":
            return "Apple TV 4"
        case "i386", "x86_64":
            return "Simulator"
        default:
            return platform
        }
        
    }
    
    /// 将大小转换成字符串用以显示
    func fileSizeToString(fileSize:Int64) -> String {
        
        let fileSize1 = CGFloat(fileSize)
        
        let KB:CGFloat = 1024
        let MB:CGFloat = KB*KB
        let GB:CGFloat = MB*KB
        
        if fileSize < 10 {
            return "0 B"
            
        } else if fileSize1 < KB {
            return "< 1 KB"
        } else if fileSize1 < MB {
            return String(format: "%.1f KB", CGFloat(fileSize1)/KB)
        } else if fileSize1 < GB {
            return String(format: "%.1f MB", CGFloat(fileSize1)/MB)
        } else {
            return String(format: "%.1f GB", CGFloat(fileSize1)/GB)
        }
    }
    
    /// 磁盘总大小
    func zz_getTotalDiskSize() -> Int64 {
        var fs = self.blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return Int64(UInt64(fs.f_bsize) * fs.f_blocks)
        }
        return -1
    }
    
    /// 磁盘可用大小
    func zz_getAvailableDiskSize() -> Int64 {
        var fs = self.blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return Int64(UInt64(fs.f_bsize) * fs.f_bavail)
        }
        return -1
    }
    
    
    func blankof<T>(type:T.Type) -> T {
        let ptr = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T>.size)
        let val = ptr.pointee
        return val
    }
    
}



