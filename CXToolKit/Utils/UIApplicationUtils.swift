//
//  UIApplicationUtils.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import UIKit

extension UIApplication {
    
    enum SettingType {
        case setting
        case schemes(String)
        case telprompt(String)
        case url(String)
        var value: String {
            switch self {
            case .telprompt(let phone):
                return "telprompt://" + phone
            case .url(let u):
                return u
            default:
                return UIApplication.openSettingsURLString
            }
        }
    }
    
    @discardableResult
    class func openURL(_ type:SettingType = .setting) -> Bool {
        guard let url = URL(string: type.value) else {
            return false
        }
        let result = UIApplication.shared.canOpenURL(url)
        if result {
            UIApplication.shared.open(url, options: [:]) { result in
                if !result {
                    print("[UIApplication] OpenURL falied : ", type.value)
                }
            }
        }
        return result
    }

}
