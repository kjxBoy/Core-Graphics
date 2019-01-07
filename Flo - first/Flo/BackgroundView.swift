//
//  BackgroundView.swift
//  Flo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019年 kang. All rights reserved.
//

import UIKit

@IBDesignable class BackgroundView: UIView {
    
    //1
    @IBInspectable var lightColor: UIColor = UIColor.orange
    @IBInspectable var darkColor: UIColor = UIColor.yellow
    // 重复的范围
    @IBInspectable var patternSize: CGFloat = 200
    
    override func draw(_ rect: CGRect) {
        //2
        let context = UIGraphicsGetCurrentContext()!
//
//        //3
//        context.setFillColor(darkColor.cgColor)
//
//        //4
//        context.fill(rect)
        
        
        let drawSize = CGSize(width: patternSize, height: patternSize)
        
        // creates a new context and sets it as the current drawing context, so you’re now drawing into this new context.
        // 创建新的context并设置为当前的context，所以当前的绘图都在这个新的context上
        // scale 传递0意味着自动适配scale
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        // 获取对此新上下文的引用。
        let drawingContext = UIGraphicsGetCurrentContext()!
        
        //set the fill color for the new context
        darkColor.setFill()
        drawingContext.fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))
        
        let trianglePath = UIBezierPath()
        //1
        trianglePath.move(to: CGPoint(x: drawSize.width/2, y: 0))
        //2
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height/2))
        //3
        trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height/2))
        
        //4
        trianglePath.move(to: CGPoint(x: 0,y: drawSize.height/2))
        //5
        trianglePath.addLine(to: CGPoint(x: drawSize.width/2, y: drawSize.height))
        //6
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height))
        
        //7
        trianglePath.move(to: CGPoint(x: drawSize.width, y: drawSize.height/2))
        //8
        trianglePath.addLine(to: CGPoint(x: drawSize.width/2, y: drawSize.height))
        //9
        trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height))
        
        lightColor.setFill()
        trianglePath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        // When you end the current context with UIGraphicsEndImageContext(), the drawing context reverts to the view’s context, so any further drawing in draw(_ rect:) happens in the view.
        UIGraphicsEndImageContext()
        
        UIColor(patternImage: image).setFill()
        context.fill(rect)
    }
}

