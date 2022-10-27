//
//  BaseViewController.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    

    var barAlpha:CGFloat = 1 {
        didSet {
            guard let navigationController = navigationController else {
                return
            }
            barTintStyle = barAlpha >= 0.5 ? .gray : .white
            let backImage = UIImage.image(.white)
            navigationController.navigationBar.setBackgroundImage(backImage, for: .default)
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    /// 懒刷新
    var refreshInterval: TimeInterval = 5.0
    var refreshTime: TimeInterval = Date().timeIntervalSince1970
    
    var isShouldRefresh: Bool {
        return (Date().timeIntervalSince1970 - refreshTime) > refreshInterval ? true : false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageView()
        setupPageLayout()
        setupPageEvent()
        sendRefreshAction()
    }
    
    deinit {
        print("[APP] \(self) Was Dealloc!")
    }
    
    func setupPageView(){}
    func setupPageLayout(){}
    func setupPageEvent(){}
    func setupThemeStyle() {
        view.backgroundColor = .white
        view.clipsToBounds = true
        barAlpha = 0
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupThemeStyle()
        
        if isShouldRefresh {
            //检测刷新
            sendRefreshAction()
        }
        
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        /// @Fixed: the item width must be less than the width of the UICollectionView minus the section insets left and right values, minus the content insets left and right values
        view.subviews.forEach { (view) in
            switch view {
            case let collectionView as UICollectionView:
                collectionView.collectionViewLayout.invalidateLayout()
                break;
            default:
                break
            }
        }
    }
    
    
    /// 标题点击
    override func titleItemAction(button: UIButton) {
     
        sendRefreshAction()
      
    }
    
    /// 下拉刷新
    @objc func sendRefreshAction() {
        refreshTime = Date().timeIntervalSince1970
    }
    
    @objc func sendMoreAction() {
        refreshTime = Date().timeIntervalSince1970
        
    }
}
