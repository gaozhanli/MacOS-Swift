//
//  ExtUIVew.swift
//  EducationAdministrators
//
//  Created by z14 on 2019/5/31.
//  Copyright © 2019年 z14. All rights reserved.
//

import Foundation
import UIKit

public enum ShakeDirection: Int
{
    case horizontal
    case vertical
}

extension UIView
{
    // MARK: - 扩展UIView,增加抖动方法
    ///
    /// - Parameters:
    ///   - direction: 抖动方向（默认是水平方向）
    ///   - times: 抖动次数（默认5次）
    ///   - interval: 每次抖动时间（默认0.1秒）
    ///   - delta: 抖动偏移量（默认2）
    ///   - completion: 抖动动画结束后的回调
    public func shake(direction: ShakeDirection = .horizontal, times: Int = 5, interval: TimeInterval = 0.1, delta: CGFloat = 2, completion: (() -> Void)? = nil)
    {
        //定义一个动画
        UIView.animate(withDuration: interval, animations: {
            
            switch direction
            {
            case .horizontal:
                self.layer.setAffineTransform(CGAffineTransform(translationX: delta, y: 0))
            case .vertical:
                self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: delta))
            }
        }) { (finish) in
            
            if times == 0
            {
                UIView.animate(withDuration: interval, animations: {
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (finish) in
                    completion?()
                })
            }
            else
            {
                self.shake(direction: direction, times: times - 1, interval: interval, delta: -delta, completion: completion)
            }
        }
    }
}
