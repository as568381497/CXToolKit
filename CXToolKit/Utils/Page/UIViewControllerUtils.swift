//
//  UIViewControllerUtils.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import Foundation
import UIKit

extension UIViewController {
    
    enum BarTintStyle:Int {
        case white = 1
        case gray
        
        var backImage:UIImage? {
            switch self {
            case .gray: return UIImage(named: "nav_back_box_gray")
            default: return UIImage(named: "nav_back_box")
            }
        }
        
        var textColor:UIColor {
            switch self {
            case .gray:
                return .black
            default:
                return UIColor.white
            }
        }
    }
    
    var barTintStyle:BarTintStyle {
        set {
            if let button = navigationItem.rightBarButtonItem?.customView as? UIButton {
                button.setTitleColor(newValue.textColor, for: .normal)
            }
            if let button = navigationItem.leftBarButtonItem?.customView as? UIButton {
                button.setTitleColor(newValue.textColor, for: .normal)
            }
            if navigationController?.children.count ?? 1 < 2 {
                return
            }
            if let leftItem = navigationItem.leftBarButtonItem, (leftItem.tag < 1 || barTintStyle == newValue){
                return
            }
            let backItem = UIBarButtonItem(image: newValue.backImage?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismissOrPopController))
            navigationItem.leftBarButtonItem = backItem
            navigationItem.leftBarButtonItem?.tag = newValue.rawValue
        }
        get {
            return BarTintStyle(rawValue: navigationItem.leftBarButtonItem?.tag ?? 1) ?? .white
        }
    }
    
    var leftItemTitle:CustomStringConvertible {
        set {
            let item = getItemTitle(newValue)
            item.setTitleColor(barTintStyle.textColor, for: .normal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: item)
        }
        get {
            switch navigationItem.leftBarButtonItem?.customView {
            case let label as UILabel: return label.attributedText?.string ?? label.text ?? ""
            case let button as UIButton: return button.attributedTitle(for: .normal)?.string ?? button.title(for: .normal) ?? ""
            default: return ""
            }
        }
    }
    var rightItemTitle:CustomStringConvertible {
        set {
            let item = getItemTitle(newValue)
            item.setTitleColor(barTintStyle.textColor, for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: item)
            
        }
        get {
            switch navigationItem.leftBarButtonItem?.customView {
            case let label as UILabel: return label.attributedText?.string ?? label.text ?? ""
            case let button as UIButton: return button.attributedTitle(for: .normal)?.string ?? button.title(for: .normal) ?? ""
            default: return ""
            }
        }
    }
    
    private var leftItemButton:UIButton? {
        if let button = navigationItem.leftBarButtonItem?.customView as? UIButton {
            return button
        }
        return nil
    }
    private var rightItemButton:UIButton? {
        if let button = navigationItem.rightBarButtonItem?.customView as? UIButton {
            return button
        }
        return nil
    }
    
    private func getItemTitle(_ title:CustomStringConvertible) -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(titleItemAction(button:)), for: .touchUpInside)
        switch title {
        case let attrTitle as NSAttributedString:
            button.setAttributedTitle(attrTitle, for: .normal)
        default:
            button.setTitle(title.description, for: .normal)
        }
        return button
    }
    
    @objc func dismissOrPopController() {
        if let navigationController = navigationController, navigationController.children.count > 1 {
            navigationController.popViewController(animated: true)
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func titleItemAction(button:UIButton) {
        /// Override
    }
    
    //获取当前的ViewController
    static func visibleViewController() -> UIViewController {
        guard var controller = UIApplication.shared.keyWindow?.rootViewController else {
            return UIViewController()
        }
        if let selectController = controller as? UITabBarController {
            if let selectController = selectController.selectedViewController {
                controller = selectController
            }
        }
        if let navigationController = controller as? UINavigationController {
            if let visiableController = navigationController.visibleViewController {
                /// Fixed：修复递归调用的问题
                if visiableController.isKind(of: UIAlertController.self) {
                    if let topViewController = navigationController.topViewController {
                        controller = topViewController
                    }
                } else {
                    controller = visiableController
                }
            }
        }
        while let presentedController = controller.presentedViewController {
            controller = presentedController;
        }
        return controller
    }
    
    
    //弹框
    static func showAlert(title:String, message:String? = nil, items:[String], callback:((Int) -> Void)?) {
        let alertController = AppAlertViewController()
        alertController.tintColor = .white
        alertController.alertTitle = title
        alertController.alertMessage = message ?? ""
        var actions:[AlertAction] = []
        
        for (i,item) in items.enumerated() {
            
            let action = AlertAction(title: item, index: i, style: .default)
            actions.append(action)
        }
        
        alertController.actions = actions
        alertController.selectItemHadler = callback
        
        UIViewController.visibleViewController().present(alertController, animated: false, completion: nil)
        
    }
    
    
    //有输入框的弹框
    static func showInputAlert(title:String, placeholder:String? = nil, items:[String], callback:((Int,String) -> Void)?) {
        let alertController = AppAlertInputViewController()
        alertController.tintColor = .white
        alertController.alertTitle = title
        alertController.InputPlaceholder = placeholder ?? ""
        var actions:[AlertAction] = []
        
        for (i,item) in items.enumerated() {
            
            
            let action = AlertAction(title: item, index: i, style: .default)
            actions.append(action)
            
        }
        
        alertController.actions = actions
        alertController.selectItemHadler = callback
        
        UIViewController.visibleViewController().present(alertController, animated: false, completion: nil)
    }
}
