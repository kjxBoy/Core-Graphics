//
//  GraphView.swift
//  Flo
//
//  Created by apple on 2018/12/6.
//  Copyright © 2018年 kang. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    //Weekly sample data
    var graphPoints = [4, 2, 6, 4, 5, 8, 3]
    
    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }

    
    // 1. 创建开始和结束的颜色，设置为@IBInspectable，保证在storyboard中可以修改这两个属性
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        
        /* 这将创建一个约束渐变的剪切区域。，而不是在全部上下文绘制
         **** start  ***/
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        /**** end   ***/

        
        // 2. CG绘图函数需要知道它们将绘制的上下文，因此您使用UIKit方法UIGraphicsGetCurrentContext（）来获取当前上下文。这个上下文就是draw(_:)函数负责绘制的
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        
        // 3. 所有上下文(context)都有颜色空间。这可能是CMYK或grayscale，但在这里你使用的是RGB色彩空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 4. 颜色定位点描述渐变中颜色的变化。在这个例子中，你只有两种颜色，红色变为绿色，
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // 5. 创建实际渐变，定义颜色空间，颜色和颜色定位点
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
         /* 6.
            * 要绘制的CGContext
            * CGGradient具有色彩空间，颜色和停止
            * 起点
            * 终点
            * 用于扩展渐变的选项标志
            */
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
        
        
        // 计算X点的坐标
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            //Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        
        // 计算Y点的坐标
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - y // Flip the graph
        }
        
        // 创建路径
        let graphPath = UIBezierPath()
        
        // 线的启点
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        

        // 根据计算公式，算出每天对应的点的X、Y
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        // 画线
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        //Create the clipping path for the graph gradient
        // 创建画布的切割线
        
        //1 - save the state of the context (commented out for now)
        context.saveGState()
        
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y:height))
        clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
        clippingPath.close()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        context.restoreGState()
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        // 在线的顶部画圆
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
            circle.fill()
        }

    
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        //center line
        linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        
        //bottom line
        linePath.move(to: CGPoint(x: margin, y:height - bottomBorder))
        linePath.addLine(to: CGPoint(x:  width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()


    }
}
