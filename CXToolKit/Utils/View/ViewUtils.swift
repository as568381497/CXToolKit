//
//  ViewUtils.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import Foundation
import UIKit
import SwiftUI

extension UIView : CAAnimationDelegate{
    
    //添加阴影以及圆角
    @discardableResult
    func setLayerShadow(color:UIColor,
                        offset:CGPoint = CGPoint(x: 0, y: 2),
                        shadowRadius:CGFloat = 4,
                        cornerRadius:CGFloat = 20,
                        shadowOpacity:Float = 1,
                        cornerShadow:Bool = false, isChangeFrame:Bool = false ,changeFrame:CGRect = CGRect()) -> UIView {
        var shadowView:UIView
        if cornerShadow {
            shadowView = self.superview?.viewWithTag(900) ?? UIView()
            shadowView.backgroundColor = UIColor.white
            shadowView.tag = 900
            shadowView.frame = isChangeFrame == false ? self.frame : changeFrame
            shadowView.autoresizingMask = self.autoresizingMask
            self.superview?.insertSubview(shadowView, belowSubview: self)
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        } else {
            shadowView = self
            shadowView.layer.masksToBounds = false
        }
        shadowView.layer.shadowColor = color.cgColor
        shadowView.layer.shadowOffset = CGSize(width: offset.x, height: offset.y)
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.cornerRadius = cornerRadius
        return shadowView
    }
    
    //部分圆角
    func setMaskCorner(corners:UIRectCorner, radius:CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }
    
    //渐变色  !!! 注意需要注意 layer 的 frame 位置
    func setGradientLayerColor(startColor:UIColor ,endColor:UIColor ,isTop:Bool = false ,isRadius:Bool = false ,isChangeFrame:Bool = false) {
        
        
        //clrar layer
        self.layer.sublayers?.forEach({ (subLayer) in
            if subLayer.isKind(of: CAGradientLayer.self) {
                subLayer.removeFromSuperlayer()
            }
        })
        
        //定义渐变的颜色（从黄色渐变到橙色）
        let gradientColors = [startColor.cgColor, endColor.cgColor]
        
        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        //默认从左到右
        if isTop == false{
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        //是否有圆角
        if isRadius == true {
            gradientLayer.cornerRadius = self.layer.cornerRadius
        }
        
        
        //设置其CAGradientLayer对象的frame，并插入view的layer
        if isChangeFrame == false{
            gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }else{
            gradientLayer.frame = self.frame
        }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    
    //清除layer并给到背景色
    func clearLayerWithBackgroundColor(viewBackgroundColor:UIColor) {
        
        
        //clrar layer
        self.layer.sublayers?.forEach({ (subLayer) in
            if subLayer.isKind(of: CAGradientLayer.self) {
                subLayer.removeFromSuperlayer()
            }
        })
        
        self.backgroundColor = viewBackgroundColor
        
    }
    
    //贝塞尔移动动画
    func imageBesselMove(beginPoint:CGPoint, endPoint:CGPoint) {
        
        let imageView:UIImageView = UIImageView(frame: CGRect(x: beginPoint.x, y: beginPoint.y, width: 30, height: 30))
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        imageView.tag = 1221
        imageView.layer.cornerRadius = 15
        self.addSubview(imageView)
        
        
        //中点  ----  贝塞尔
        let centerPoint:CGPoint = CGPoint(x: (beginPoint.x + endPoint.x) * 0.4, y: (beginPoint.y + endPoint.y) * 0.4)
        
        let quadPath = UIBezierPath()
        quadPath.move(to: beginPoint)
        quadPath.addQuadCurve(to: endPoint, controlPoint: centerPoint)
        
        let animationPath = CAKeyframeAnimation.init(keyPath: "position")
        animationPath.rotationMode = .rotateAuto
        animationPath.path = quadPath.cgPath
        
        let scale:CABasicAnimation = CABasicAnimation()
        scale.keyPath = "transform.scale"
        scale.toValue = 0.2
        
        let animationGroup:CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [animationPath ,scale];
        animationGroup.duration = 0.5
        animationGroup.delegate = self
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        imageView.layer.add(animationGroup, forKey:
                    nil)
        
    }
    
    
    //// CAAnimationDelegate 动画完成后清理
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        for subviewItem in self.subviews{
            
            if subviewItem.tag == 1221{
                subviewItem.removeFromSuperview()
            }
            
        }
        
    }
    
    
    //虚线
    @discardableResult
    func setDashLineLayer(width:CGFloat = 2, length:CGFloat = 4, spacer:CGFloat = 6, color:UIColor = .red, isHorizonal:Bool = true) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        if isHorizonal {
            shapeLayer.position = CGPoint(x: frame.size.width/2, y: frame.size.height)
        } else {
            shapeLayer.position = CGPoint(x: frame.size.width, y: frame.size.height/2)
        }
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [length as NSNumber, spacer as NSNumber]
        shapeLayer.lineWidth = width
        let path = CGMutablePath()
        if isHorizonal {
            path.move(to: CGPoint(x: spacer, y: 0))
            path.addLine(to: CGPoint(x: frame.size.width - spacer, y: 0))
        } else {
            path.move(to: CGPoint(x: 0, y: spacer))
            path.addLine(to: CGPoint(x: 0, y: frame.size.height - spacer))
        }
        shapeLayer.path = path
        layer.sublayers?.forEach({ (subLayer) in
            if subLayer.isKind(of: CAShapeLayer.self) {
                subLayer.removeFromSuperlayer()
            }
        })
        layer.addSublayer(shapeLayer)
        return shapeLayer
    }
    
    /// view 获取 验证码倒计时
    @discardableResult
    func verficationCodeCountdownTimer(duration:TimeInterval = 60, interval:Double = 1) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: interval)
        timer.setCancelHandler {
            DispatchQueue.main.async { [weak self] in
                let message = "重新发送验证码"
                switch self {
                case let label as UILabel:
                    label.text = message
                case let button as UIButton:
                    button.isEnabled = true
                    button.setTitle(message, for: .normal)
                default:
                    break
                }
                self?.isUserInteractionEnabled = true
            }
        }
        var timeInterval:TimeInterval = duration
        timer.setEventHandler {
            timeInterval -= 1
            DispatchQueue.main.async { [weak self] in
                if timeInterval <= 0 {
                    timer.cancel()
                } else {
                    let message = String(format: "重试请等待 %.0lf 秒", timeInterval)
                    switch self {
                    case let label as UILabel:
                        label.text = message
                    case let button as UIButton:
                        button.isEnabled = false
                        button.setTitle(message, for: .disabled)
                    default:
                        break
                    }
                    self?.isUserInteractionEnabled = true
                }
            }
        }
        timer.resume()
        return timer
    }
    
    
}
