//
//  THVipAssetChartMarkerView.swift
//  GDDemo
//
//  Created by GDD on 2019/5/27.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit
import Charts

class THVipAssetChartMarkerView: MarkerView {
    public var xAxisValueFormatter: IAxisValueFormatter
    fileprivate var color: UIColor
    fileprivate var circleColor: UIColor
    fileprivate var space:CGFloat = 3.5
    fileprivate var font: UIFont
    fileprivate var textColor: UIColor
    fileprivate var insets: UIEdgeInsets
    fileprivate var minimumSize = CGSize()
    fileprivate var text: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()
    
    open var valueRadius: CGFloat = 4.0
    open var circleRadius: CGFloat = 2.5
    open var valueSpace: CGFloat = 8
    open var valueInset: UIEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    open var valueSize: CGSize = CGSize.zero
    open var valueColor: UIColor = UIColor.hex(0x696Fd8)
    open var valueFont: UIFont = UIFont.pingFangRegularFont(size: 10)!
    open var valueText1: String = ""
    open var valueText2: String = ""
    open var valueTextColor: UIColor = UIColor.hex(0x777777)
    open var value2CircleColor: UIColor = UIColor.hex(0x696Fd8)
    open var valueParagraphStyle: NSMutableParagraphStyle?
    open var valueDrawAttributes = [NSAttributedString.Key : Any]()

    public init(frame: CGRect, xAxisValueFormatter: IAxisValueFormatter) {
        self.xAxisValueFormatter = xAxisValueFormatter
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        valueParagraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        valueParagraphStyle?.alignment = .left
        self.color = UIColor.hex(0xf0f1ff)
        self.font = UIFont.pingFangRegularFont(size: 10)!
        self.textColor = UIColor.hex(0x696Fd8)
        self.insets = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
        self.circleColor = UIColor.white
        self.value2CircleColor = UIColor.hex(0xff684E)
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        if let color = entry.data as? UIColor {
            self.circleColor = color
        }
        setLabel(String(entry.x))
        //TODO 这里需要从entry.data里读取渲染
        setValue(value1: "持有资产：6789.77", value2: "价格：34566")
    }
    
    @objc open func setLabel(_ newLabel: String)
    {
        text = newLabel
        
        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        
        _labelSize = newLabel.size(withAttributes: _drawAttributes)
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
    
    open func setValue(value1: String, value2: String) {
        let value = value1.count > value2.count ? value1 : value2
        valueText1 = value1
        valueText2 = value2
        valueDrawAttributes.removeAll()
        valueDrawAttributes[.font] = self.valueFont
        valueDrawAttributes[.paragraphStyle] = valueParagraphStyle
        valueDrawAttributes[.foregroundColor] = self.valueTextColor

        let labelSize = value.size(withAttributes: valueDrawAttributes)

        var size = CGSize()
        size.width = labelSize.width + self.valueInset.left + self.valueInset.right + valueSpace
        size.height = labelSize.height*2 + self.valueInset.top + self.valueInset.bottom
        self.valueSize = size
    }
    

    override func draw(context: CGContext, point: CGPoint) {
        drawLabel(context: context, point: point)
        drawCircle(context: context, point: point)
        drawValue(context: context, point: point)
    }
    
    /// 绘制底部变化的时间框
    ///
    private func drawLabel(context: CGContext, point: CGPoint) {
        let size = self.size
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y = chartView!.height - (chartView?.viewPortHandler.offsetBottom)!
        
        context.saveGState()
        context.setFillColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(
            x: rect.origin.x ,
            y: rect.origin.y))
        context.addRect(rect)
        context.fillPath()
        
        
        if offset.y > 0 {
            rect.origin.y += self.insets.top
        } else {
            rect.origin.y += self.insets.top
        }
        
        rect.size.height -= self.insets.top + self.insets.bottom
        rect.size.width -= self.insets.left + self.insets.right
        rect.origin.x += self.insets.left
        
        UIGraphicsPushContext(context)
        
        text!.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
        
    }
    
    /// 绘制高亮十字交叉的圆圈
    private func drawCircle(context: CGContext, point: CGPoint) {
        let path = CGMutablePath()
        path.addArc(center: point,  radius: 2.5, startAngle: 0,
                    endAngle: CGFloat.pi * 2, clockwise: true)
        
        context.addPath(path)
        context.setFillColor(UIColor.white.cgColor)
        UIColor.white.setFill()
        context.fillPath()
        path.addArc(center: point,  radius: 3, startAngle: 0,
                    endAngle: CGFloat.pi * 2, clockwise: true)
        context.addPath(path)
        context.setStrokeColor(circleColor.cgColor)
        circleColor.setStroke()
        context.setLineWidth(0.5)
        context.strokePath()
    }
    
    /// 绘制持有资产的小方框
    ///
    private func drawValue(context: CGContext, point: CGPoint) {
        let size = self.valueSize
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        if point.x < chartView!.width/2.0 && point.x - size.width > chartView!.viewPortHandler.offsetLeft ||
            point.x + size.width > chartView!.width - chartView!.viewPortHandler.offsetRight{
            rect.origin.x = point.x - size.width
        }else {
            rect.origin.x = point.x
        }
        rect.origin.y = (chartView?.viewPortHandler.offsetTop)!
        
        context.saveGState()
        
        context.setStrokeColor(valueColor.cgColor)
        context.setLineWidth(1)
        
        
        context.beginPath()
        context.move(to: CGPoint(
            x: rect.origin.x +  valueRadius,
            y: rect.origin.y))
        
        //arrow vertex
        
        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width -  valueRadius,
            y: rect.origin.y))
        context.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY ),
                       tangent2End: CGPoint(x: rect.maxX, y: rect.minY  +  valueRadius),
                        radius:  valueRadius)
        context.addLine(to: CGPoint(
            x: rect.origin.x + rect.size.width,
            y: rect.origin.y + rect.size.height -  valueRadius))
        
        context.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY ),
                       tangent2End: CGPoint(x: rect.maxX -  valueRadius, y: rect.maxY ),
                        radius:  valueRadius)
        
        context.addLine(to: CGPoint(
            x: rect.origin.x +  valueRadius,
            y: rect.origin.y + rect.size.height))
        
        context.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY  ),
                       tangent2End: CGPoint(x: rect.minX, y: rect.maxY  -  valueRadius),
                        radius:  valueRadius)
        
        context.addLine(to: CGPoint(
            x: rect.origin.x,
            y: rect.origin.y  +  valueRadius))
        
        context.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY ),
                       tangent2End: CGPoint(x: rect.minX +  valueRadius, y: rect.minY ),
                        radius:  valueRadius)
        
        context.strokePath()
        
        if offset.y > 0 {
            rect.origin.y += self.valueInset.top
        } else {
            rect.origin.y += self.valueInset.top
        }
        
        var path = CGMutablePath()
        var circlePoint = CGPoint.init(x: rect.origin.x + circleRadius + self.valueInset.left,
                                       y: rect.origin.y - circleRadius + self.valueInset.top + 5)
        path.addArc(center: circlePoint,  radius: circleRadius, startAngle: 0,
                    endAngle: CGFloat.pi * 2, clockwise: true)
        
        context.addPath(path)
        valueColor.setFill()
        context.fillPath()
        
        
        
        path = CGMutablePath()
        circlePoint = CGPoint.init(x: rect.origin.x + circleRadius + self.valueInset.left,
                                   y: rect.origin.y + rect.size.height / 2.0 + 2.5)
        path.addArc(center: circlePoint,  radius: circleRadius, startAngle: 0,
                    endAngle: CGFloat.pi * 2, clockwise: true)
        
        context.addPath(path)
        value2CircleColor.setFill()
        context.fillPath()
        
        rect.size.height = rect.size.height - (self.valueInset.top + self.valueInset.bottom)
        rect.size.width -= self.valueInset.left + self.valueInset.right + valueSpace
        rect.origin.x += self.valueInset.left + valueSpace
        
        UIGraphicsPushContext(context)
        valueText1.draw(in: rect, withAttributes: valueDrawAttributes)
        rect.origin.y += rect.size.height/2.0
        valueText2.draw(in: rect, withAttributes: valueDrawAttributes)

        UIGraphicsPopContext()
        
        context.restoreGState()
    }

}
