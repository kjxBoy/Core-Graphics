[原文Core Graphics Tutorial](https://www.raywenderlich.com/90695/modern-core-graphics-with-swift-part-2)

[Github](https://github.com/kjxBoy/Core-Graphics)

`Core Graphics` 是苹果内的`矢量绘图框架`, 包含大量的可使用的`API`

### View的自定义绘图(Custom Drawing on Views)
在`View`自定义就两个步骤：
> * 创建一个`View`的子类(`subClass`)
> * 重写`draw(_:)`方法，并在方法里添加一些`Core Graphics`的绘制代码

### 画一个Button（Drawing the Button）
关于绘制图片的路径有三个基本要点
> `path`：可以被绘制和填充的线条
>  `stroke`：路径的绘制(`stroke`)轮廓的颜色，是当前的绘制颜色
>  `fill`：使用当前的填充颜色填满封闭的路径

（英文更能突出三个点：）
> *  A `path` can be stroked and filled.
> *  A `stroke` outlines the path in the current stroke color.
> *  A `fill` will fill up a closed path with the current fill color.

使用贝塞尔路径(`UIBezierPath`)创建`Core Graphics`的`path`更加容易
  
> * 路径(`paths`)本身不会绘制任何东西。您可以定义没有可用绘图上下文(`drawing context`)的路径。
> * 要绘制路径(`path`)，请在当前上下文中设置填充颜色（下面有更多内容可做）
> * 填充路径(`fill` the `path`)

``` swift
override func draw(_ rect: CGRect) {
        //1.路径本身不会绘制任何东西。您可以定义没有可用绘图上下文的路径。
        let path = UIBezierPath(ovalIn: rect)
        //2. 要绘制路径，请在当前上下文中设置填充颜色
        UIColor.green.setFill()
        //3. 填充路径。
        path.fill()
    }
```

### 核心绘图(Core Graphs)的幕后原理

每个`UIView`都有一个图形上下文(`graphics context`)，视图的所有绘图在传输到设备的硬件之前呈现在此上下文中。

每当视图需要更新时，`iOS`都会通过调用`draw（_ :)`来更新上下文(`context`)。这种情况发生在：

 * 视图刚刚添加到屏幕上
 * 移动了顶部视图
 * 视图的隐藏属性(`hidden property`)已更改
 * 应用程序显式调用视图(`View`)上的`setNeedsDisplay（）`或`setNeedsDisplayInRect（）`方法。

>*注意*：在`draw（_ :)`中完成的任何绘图都会进入视图的图形上下文(`view’s graphics context`)。请注意，如果您绘制在`draw(_ :)`方法之外，您将必须创建自己的图形上下文(`graphics context`)。

您还没有在本教程中使用过`Core Graphics`，因为`UIKit`包含许多`Core Graphics`函数的包装器。例如，`UIBezierPath`是`CGMutablePath`的包装器，`CGMutablePath`是较低级别的`Core Graphics API`。
> *注意* ： 不要直接调用`draw(_:)`, 如果您的视图未更新，请在视图上调用`setNeedsDisplay()`.
`setNeedsDisplay()`本身不调用`draw（_ :)`，但它将视图标记为'脏(`dirty`)'，在下一个屏幕更新周期使用`draw（_ :)`触发重绘。即使你在同一个方法中调用`setNeedsDisplay()`五次，你也只能实际调用`draw（_ :)`一次。

### @IBDesignable – 交互式绘制
通过在你要绘制的类前面添加`@IBDesignable`字段，可以让你`实时`查看绘制展示

### 绘制到上下文中
`Core Graphics` 采用一种`画家模式`进行绘制，它几乎就像画一幅画。您铺设一条路并填充它。之后你可以在它上面画另外一条路径并填充它。您无法更改已放置的像素，但是您可以在它上面继续绘制。(就是类似绘制的一层、一层进行)

画线的代码如下

``` swift
// 添加一些线的宽高位置的属性
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
```
画线
``` swift
//set up the width and height variables
//for the horizontal stroke
let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
let halfPlusWidth = plusWidth / 2

//create the path
let plusPath = UIBezierPath()

//set the path's line width to the height of the stroke
plusPath.lineWidth = Constants.plusLineWidth

//move the initial point of the path
//to the start of the horizontal stroke
plusPath.move(to: CGPoint(
  x: halfWidth - halfPlusWidth,
  y: halfHeight))

//add a point to the path at the end of the stroke
plusPath.addLine(to: CGPoint(
  x: halfWidth + halfPlusWidth,
  y: halfHeight))

//set the stroke color
UIColor.white.setStroke()

//draw the stroke
plusPath.stroke()
```
![中间的白线](http://upload-images.jianshu.io/upload_images/328144-0f5b619b0381e27d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 像素和点

![使用居中设置宽度的stroke可能出现锯齿的原因](http://upload-images.jianshu.io/upload_images/328144-f6a4d642bb7b4018.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

对于像素完美线条，您可以绘制(`draw`)和填充(`fill`) `UIBezierPath（rect :)` 而不是线条，并使用视图的`contentScaleFactor`来计算矩形的宽度和高度。与从路径中心向外绘制的笔划不同，填充仅在路径内绘制。

### @IBInspectable – 自定义故事板属性
 在自定义的PushButton中，添加了两个属性
``` swift
 @IBInspectable var fillColor: UIColor = UIColor.green
 @IBInspectable var isAddButton: Bool = true
```
使用`@IBInspectable`声明的两个属性显示在`Attributes Inspector`的顶部：

![@IBInspectable的两个属性](http://upload-images.jianshu.io/upload_images/328144-fce1538d6d27a431.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 使用UIBezierPath画弧线

![图](http://upload-images.jianshu.io/upload_images/328144-c004efdc2db6667c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`画橘色的部分`
```swift
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

```

`画两条外边线`
```swift

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
```

您已经学习了如何使用`Core Graphics`绘制`线条(lines)`和`弧线(arcs)`，以及使用`Xcode`的`storyboard`的交互式功能。

接下来，您将深入研究`Core Graphics`，了解`drawing gradients`(绘制渐变)和使用转换(`transformation`)操作`CGContexts`。

#### Core Graphics

`warning`: 你现在要离开`UIKit`的舒适世界，进入`Core Graphics`的黑暗社会。

`Apple`的这张图片从概念上描述了相关的框架：

![相关的框架](http://upload-images.jianshu.io/upload_images/328144-6d487c5ed961735a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`UIKit`是最顶层的，也是最平易近人的。您已经使用了`UIBezierPath`，它是`Core Graphics CGPath`的`UIKit`包装器。

`Core Graphics`框架基于`Quartz`高级绘图引擎。它提供底层，轻量级的2D渲染。您可以使用此框架来处理基于路径的绘图，转换，颜色管理等等。

关于底层`Core Graphics`对象和函数的一件事是它们总是有前缀`CG`，所以它们很容易识别。

#### 开始

![本节最后的目标](http://upload-images.jianshu.io/upload_images/328144-70b7f0c0b318de0b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在绘制图表视图之前，您将在`storyboard`中进行设置，并创建动画转换的代码以显示图表视图。

完整的视图层次结构如下所示：

![视图层级](http://upload-images.jianshu.io/upload_images/328144-eab39eff359a9421.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 绘图顺序分析

还记得第1部分中的`Painter`模型吗？它解释了使用`Core Graphics`绘图是从图像背面到前面完成的，因此在编码之前需要记住订单。对于Flo的图，那将是：
![绘图顺序](http://upload-images.jianshu.io/upload_images/328144-c068789273c1000a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 1. 渐变背景视图
> 2. 图下的剪裁渐变
> 3. 图线
> 4. 图表的圆圈指向
> 5. 水平图线
> 6. 图表标签

#### 绘制渐变

```swift
override func draw(_ rect: CGRect) {
        
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
        
        // 6
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        /*
         * 要绘制的CGContext
         * CGGradient具有色彩空间，颜色和停止
         * 起点
         * 终点
         * 用于扩展渐变的选项标志
         */
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
    }
```
#### 剪裁区域(Clipping Areas)

刚刚使用渐变(`gradient`)时，您填充了整个视图的上下文区域。但是，您可以创建用作剪切区域的`path`(用于剪切而不是用于绘制）。剪切区域允许您定义要填充的区域，而不是整个上下文。

在上面的`draw(_ : )` 头部添加方法
``` swift
let path = UIBezierPath(roundedRect: rect,
                  byRoundingCorners: .allCorners,
                        cornerRadii: Constants.cornerRadiusSize)
path.addClip()
```
这将创建一个约束渐变的剪切区域。您将很快使用相同的技巧在图线下绘制第二个渐变。

构建并运行应用程序，看看你的图表视图有漂亮的圆角：

![带圆角的图](http://upload-images.jianshu.io/upload_images/328144-8769449988750af1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果要Clip某个部分，可以保留住上下文状态
``` swift
context.saveGState()
... ...（这里是执行clip等操作的地方，这里的绘制上下文，会变成clip的部分）
context.restoreGState()
```

> `注意:` 使用`Core Graphics`绘制静态视图通常足够快，但如果您的视图移动或需要频繁重绘，则应使用`Core Animation layers`。` Core Animation`经过优化，使用`GPU`（而不是`CPU`）处理大部分需求。相反，`CPU`处理`Core Graphics`在`draw（_ :)`中执行的视图绘制(`view drawing`)。
> 您可以使用`CALayer`的`cornerRadius`属性创建圆角，而不是使用剪切路径，但您应该针对您的情况进行优化。有关此概念，请查看 [Custom Control Tutorial for iOS and Swift: A Reusable Knob ](http://www.raywenderlich.com/82058/custom-control-tutorial-ios-swift-reusable-knob)，您将使用Core Animation创建自定义控件。


 创建新的`context`并设置为`current context`，所以当前的绘图都在这个新的`context`上
```swift
        // scale 传递0意味着自动适配scale
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        // 获取对此新上下文的引用。
        let drawingContext = UIGraphicsGetCurrentContext()!
```




