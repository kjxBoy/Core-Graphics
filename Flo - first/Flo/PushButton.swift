//
//  PushButton.swift
//  Flo
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018年 kang. All rights reserved.
//

import UIKit

@IBDesignable
class PushButton: UIButton {
    
    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    
    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var isAddButton: Bool = true
    
    override func draw(_ rect: CGRect) {
        // 1.画圆
        //1.1路径本身不会绘制任何东西。您可以定义没有可用绘图上下文的路径。
        let path = UIBezierPath(ovalIn: rect)
        //1.2 要绘制路径，请在当前上下文中设置填充颜色（下面有更多内容）
        fillColor.setFill()
        //1.3 填充路径。
        path.fill()
        
        // 2. 画水平线
        // 2.1设置水平线的宽和高(宽和高相等，为长度的0.6)
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        
        // 2.2 创建路径
        let plusPath = UIBezierPath()
        
        // 2.3设置线宽
        plusPath.lineWidth = Constants.plusLineWidth

        // 各增加0.5个点是为了抗锯齿
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
            x: halfWidth - halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift)
        )
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x: halfWidth + halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift)
        )

        if isAddButton {
            //Vertical Line
            plusPath.move(to: CGPoint(
                x: halfWidth + Constants.halfPointShift,
                y: halfHeight - halfPlusWidth + Constants.halfPointShift)
            )
            
            plusPath.addLine(to: CGPoint(
                x: halfWidth + Constants.halfPointShift,
                y: halfHeight + halfPlusWidth + Constants.halfPointShift)
            )
        }
        
        
        
        //set the stroke color
        UIColor.white.setStroke()
        
        //draw the stroke
        plusPath.stroke()
    }
}
