//
//  CounterView.swift
//  Flo
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 kang. All rights reserved.
//

import UIKit

@IBDesignable
class CounterView: UIView {
    
    /** 创建一个包含常量的结构。这些常数将在绘图时使用
     * numberOfGlasses : 每天饮水最大值
     */
    private struct Constants {
        static let numberOfGlasses = 8
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
        
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    // 饮水的计数
    @IBInspectable var counter: Int = 5 {
        didSet {
            if counter <=  Constants.numberOfGlasses {
                //the view needs to be refreshed
                /*
                 * 1.视图刚刚添加到屏幕上
                 * 2.移动了顶部视图
                 * 3.视图的隐藏属性(hidden property)已更改
                 * 4.应用程序显式调用视图(View)上的setNeedsDisplay（）或setNeedsDisplayInRect（）方法。
                 */
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange
    
    override func draw(_ rect: CGRect) {
        /// ****** 画橘黄色的背景 ******
        // 1.定义视图的中心点，您可以在其中旋转圆弧。
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        // 2.根据视图的最大尺寸，计算圆弧的半径
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // 3.定义弧的起始角和终止角。
        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4
        
        // 4.根据刚刚定义的中心点，半径和角度创建路径。
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - Constants.arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        
        
        // 5.在最终描边路径之前设置线宽和颜色。
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        
        //****** 画边框线 ******
        
        //1.首先计算两个角度之间的差异，确保它是正的
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
        //2. 计算每杯水的弧度
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
        //3. 计算出当前喝水的弧度
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle
        
        //4. 绘制外弧
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width/2 - Constants.halfOfLineWidth,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        
        //5. 绘制内弧
        /*
         向第一个弧添加内弧。它具有相同的角度但反向绘制（顺时针设置为false）。此外，这会自动在内弧和外弧之间画一条线。
         */
        outlinePath.addArc(withCenter: center,
                           radius: bounds.width/2 - Constants.arcWidth + Constants.halfOfLineWidth,
                           startAngle: outlineEndAngle,
                           endAngle: startAngle,
                           clockwise: false)
        
        //6 关闭路径
        outlinePath.close()

        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
        
        //Counter View markers
        let context = UIGraphicsGetCurrentContext()!
        
        //1 - save original state
        context.saveGState()
        outlineColor.setFill()
        
        let markerWidth: CGFloat = 5.0
        let markerSize: CGFloat = 10.0
        
        //2 - the marker rectangle positioned at the top left
        let markerPath = UIBezierPath(rect: CGRect(x: -markerWidth / 2, y: 0, width: markerWidth, height: markerSize))
        
        //3 - move top left of context to the previous center position
        context.translateBy(x: rect.width / 2, y: rect.height / 2)
        
        for i in 1...Constants.numberOfGlasses {
            //4 - save the centred context
            context.saveGState()
            //5 - calculate the rotation angle
            let angle = arcLengthPerGlass * CGFloat(i) + startAngle - .pi / 2
            //rotate and translate
            context.rotate(by: angle)
            context.translateBy(x: 0, y: rect.height / 2 - markerSize)
            
            //6 - fill the marker rectangle
            markerPath.fill()
            //7 - restore the centred context for the next rotate
            context.restoreGState()
        }
        
        //8 - restore the original state in case of more painting
        context.restoreGState()

    }
}
