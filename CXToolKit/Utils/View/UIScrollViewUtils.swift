//
//  UIScrollViewUtils.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import UIKit
import MJRefresh
import SwiftUI


extension UIScrollView {
    
    //刷新
    var showRefresh:Bool {
        set {
            if newValue {
                defaultRefreshHeaderWithSelector(#selector(sendRefreshAction), target: delegate ?? self)
                setRefreshTintColor(color: .black)
                var state:MJRefreshState = .idle
                while state.rawValue < MJRefreshState.noMoreData.rawValue {
                    if state.rawValue != MJRefreshState.pulling.rawValue {
                        setRefreshHeader(title: " ", state: state)
                    }
                    state = MJRefreshState(rawValue: state.rawValue + 1) ?? .noMoreData
                }
            } else {
                mj_header = nil
            }
        }
        get {
            return mj_header != nil ? true : false
        }
    }
    
    //加载更多
    var showMore:Bool {
        set {
            if newValue {
                defaultRefreshFooterWithSelector(#selector(sendMoreAction), target: delegate ?? self)
                setRefreshTintColor(color: .black)
            } else {
                mj_footer = nil
            }
        }
        get {
            return mj_footer != nil ? true : false
        }
    }
    
    @discardableResult
    func defaultRefreshHeaderWithSelector(_ selector:Selector, target:Any) ->  MJRefreshHeader? {
        let header = MJRefreshNormalHeader(refreshingTarget: target, refreshingAction: selector)
        header.loadingView?.style = .large
        header.stateLabel?.font = .systemFont(ofSize: 14, weight: .thin)
        header.lastUpdatedTimeLabel?.font = .systemFont(ofSize: 14, weight: .thin)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.arrowView?.image = UIImage(named: "logo_24")
        header.labelLeftInset = 0
        mj_header = header;
        return header;
    }
    
    @discardableResult
    func defaultRefreshFooterWithSelector(_ selector:Selector, target:Any) ->  MJRefreshFooter? {
        let footer = MJRefreshBackStateFooter(refreshingTarget: target, refreshingAction: selector)
        footer.stateLabel?.font = .systemFont(ofSize: 15, weight: .thin)
        footer.stateLabel?.textColor = .darkText
        mj_footer = footer;
        return footer;
    }
    
    func setRefreshTintColor(color:UIColor = .red) {
        switch mj_header {
        case let header as MJRefreshNormalHeader:
            header.stateLabel?.textColor = color
            header.lastUpdatedTimeLabel?.textColor = color
        default:
            break
        }
        switch mj_footer {
        case let footer as MJRefreshBackStateFooter:
            footer.stateLabel?.textColor = color
        default:
            break
        }
    }
    
    func setRefreshHeader(title:String, state:MJRefreshState) {
        switch mj_header {
        case let header as MJRefreshStateHeader:
            header.setTitle(title, for: state)
        default:
            break
        }
    }
    
    func setRefreshFooter(title:String, state:MJRefreshState) {
        switch mj_footer {
        case let footer as MJRefreshBackStateFooter:
            footer.setTitle(title, for: state)
        default:
            break
        }
    }
    
    //停止加载
    func endRefreshing() {
        if mj_header?.isRefreshing ?? false {
            mj_header?.endRefreshing()
        }
        if mj_footer?.isRefreshing ?? false {
            mj_footer?.endRefreshing()
        }
    }
    
    @objc func sendRefreshAction() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1)) { [weak self] in
            self?.mj_header?.endRefreshing()
        }
    }
    
    @objc func sendMoreAction() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1)) { [weak self] in
            self?.mj_footer?.endRefreshing()
        }
    }
    
}
