//
//  BezierCircleStyle2View.swift
//  GDDemo
//
//  Created by GDD on 2021/10/25.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class BezierCircleStyle2View: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var colorLayer: CAShapeLayer!
    private var levelPoints:[CGPoint] = []
    private var animationLayer: CAShapeLayer!
    private var score: Double = 700
    private var maxScore: Double = 1000
    private var scoreWidth: Double = 0
    private var animationArrowLayer: CAShapeLayer!
    private var animationTextLayer: CATextLayer!
    private var animationFlagLayer: CAShapeLayer!
}


extension BezierCircleStyle2View {
    func setupUI() {
        let baseLinePath = UIBezierPath()
        baseLinePath.move(to: CGPoint.init(x: 0, y: self.height/2))
        baseLinePath.addLine(to: CGPoint.init(x: self.width, y: self.height/2))
        let baseLineLayer = CAShapeLayer()
        baseLineLayer.frame = self.bounds
        baseLineLayer.strokeColor =  UIColor.hex(0xD8D8D8).cgColor
        baseLineLayer.fillColor = UIColor.clear.cgColor
        baseLineLayer.lineWidth = 4
        baseLineLayer.strokeStart = 0
        baseLineLayer.strokeEnd = 1
        baseLineLayer.lineCap = .round
        baseLineLayer.path = baseLinePath.cgPath
        self.layer.addSublayer(baseLineLayer)
        
        let colorLinePath = UIBezierPath()
        colorLinePath.move(to: CGPoint.init(x: 0, y: self.height/2))
        scoreWidth = self.score/self.maxScore*self.width
        colorLinePath.addLine(to: CGPoint.init(x: scoreWidth, y: self.height/2))
        colorLayer = CAShapeLayer()
        colorLayer.frame = self.bounds
        colorLayer.strokeColor =  UIColor.hex(0xF9C784).cgColor
        colorLayer.fillColor = UIColor.clear.cgColor
        colorLayer.lineWidth = 4
        colorLayer.strokeStart = 0
        colorLayer.strokeEnd = 1
        colorLayer.lineCap = .round
        colorLayer.path = colorLinePath.cgPath
        self.layer.addSublayer(colorLayer)
        
        for i in 0..<8 {
            let point = CGPoint.init(x: self.width/7*Double(i), y: self.height/2)
            levelPoints.append(point)
            let dotPath = UIBezierPath.init(arcCenter: point, radius: 2, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
            let dotLayer = CAShapeLayer()
            dotLayer.frame = self.bounds
            if point.x > scoreWidth {
                dotLayer.strokeColor = UIColor.hex(0xD8D8D8).cgColor
                dotLayer.fillColor = UIColor.hex(0xD8D8D8).cgColor
            } else {
                dotLayer.strokeColor = UIColor.hex(0xF9C784).cgColor
                dotLayer.fillColor = UIColor.hex(0xF9C784).cgColor
            }
            dotLayer.lineWidth = 2
            dotLayer.strokeStart = 0
            dotLayer.strokeEnd = 1
            dotLayer.lineCap = .round
            dotLayer.path = dotPath.cgPath
            self.layer.addSublayer(dotLayer)
            
            let string = "V\(i+1)"
            let textLayer = CATextLayer()
            textLayer.string = string
            let size = CGSize.init(width: 20, height: 20)
            textLayer.frame.size = size
            textLayer.frame.origin = CGPoint.init(x: point.x - size.width/2, y: point.y + 13)
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.fontSize = 14
            if point.x > scoreWidth {
                textLayer.foregroundColor =  UIColor.hex(0xD8D8D8).cgColor
            } else {
                textLayer.foregroundColor =  UIColor.hex(0xF9C784).cgColor
            }
            self.layer.addSublayer(textLayer)

        }
        
        let animatPath = UIBezierPath.init(arcCenter: CGPoint.init(x: 3, y: 3), radius: 3, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
        animationLayer = CAShapeLayer()
        animationLayer.frame = CGRect.init(x: -3, y: self.height/2 - 3, width: 6, height: 6)
        animationLayer.strokeColor = UIColor.hex(0xF9C784).cgColor
        animationLayer.fillColor = UIColor.white.cgColor
        animationLayer.lineWidth = 2
        animationLayer.strokeStart = 0
        animationLayer.strokeEnd = 1
        animationLayer.lineCap = .round
        animationLayer.path = animatPath.cgPath
        self.layer.addSublayer(animationLayer)
        let point = CGPoint.init(x: 0, y: self.height/2)
        drawHighlightContentLayer(point: point, at: 0)
        drawFlagLayer(point: CGPoint.init(x: scoreWidth, y: self.height/2))
    }
    
    
    func drawHighlightContentLayer(point: CGPoint, at index: Int) {
        let path = UIBezierPath()

        if animationArrowLayer == nil {
            animationArrowLayer = CAShapeLayer()
            let frame = CGRect.init(x: point.x - 15, y: point.y + 10, width: 30, height: 26)
            let point = CGPoint.init(x: 15, y: 0)
            animationArrowLayer.frame = frame
            animationArrowLayer.strokeStart = 0
            animationArrowLayer.strokeEnd = 1
            animationArrowLayer.fillColor = UIColor.hex(0xF9C784).cgColor

            path.move(to: CGPoint.init(x: point.x, y: point.y))
            path.addLine(to: CGPoint.init(x: point.x - 5, y: point.y + 6))
            path.addLine(to: CGPoint.init(x: point.x - 13, y: point.y + 6))
            path.addQuadCurve(to: CGPoint.init(x: point.x - 15, y: point.y + 8), controlPoint: CGPoint.init(x: point.x - 15, y: point.y + 6))
            path.addLine(to: CGPoint.init(x: point.x - 15, y: point.y + 26))
            path.addQuadCurve(to: CGPoint.init(x: point.x - 13, y: point.y + 28), controlPoint: CGPoint.init(x: point.x - 15, y: point.y + 28))
            path.addLine(to: CGPoint.init(x: point.x + 13, y: point.y + 28))
            path.addQuadCurve(to:  CGPoint.init(x: point.x + 15, y: point.y + 26), controlPoint:  CGPoint.init(x: point.x + 15, y: point.y + 28))
            path.addLine(to: CGPoint.init(x: point.x + 15, y: point.y + 8))
            path.addQuadCurve(to:  CGPoint.init(x: point.x + 13, y: point.y + 6), controlPoint:  CGPoint.init(x: point.x + 15, y: point.y + 6))
            path.addLine(to: CGPoint.init(x: point.x + 5, y: point.y + 6))
            path.addLine(to: CGPoint.init(x: point.x, y: point.y))
            
            self.layer.addSublayer(animationArrowLayer)
            

        }

        if animationTextLayer == nil {
            animationTextLayer = CATextLayer()
            let frame = CGRect.init(x: 0, y: 8, width: 30, height: 20)
            animationTextLayer.frame = frame
            animationTextLayer.contentsScale = UIScreen.main.scale
            animationTextLayer.fontSize = 14
            animationTextLayer.alignmentMode = .center
            animationTextLayer.foregroundColor =  UIColor.white.cgColor
            animationArrowLayer.addSublayer(animationTextLayer)
        }
        let string = "V\(index+1)"
        animationTextLayer.string = string
        animationArrowLayer.path = path.cgPath

    }
    
    func drawFlagLayer(point: CGPoint) {
        let path = UIBezierPath()

        if animationFlagLayer == nil {
            animationFlagLayer = CAShapeLayer()
            let frame = CGRect.init(x: point.x - 5, y: point.y - 16, width: 10, height: 12)
            animationFlagLayer.frame = frame
            animationFlagLayer.strokeStart = 0
            animationFlagLayer.strokeEnd = 1
            animationFlagLayer.fillColor = UIColor.hex(0xF9C784).cgColor
            let point = CGPoint.init(x: 5, y: 12)
            path.move(to: CGPoint.init(x: point.x, y: point.y))
            path.addLine(to: CGPoint.init(x: point.x - 5, y: point.y - 6))
            path.addArc(withCenter: CGPoint.init(x: 5, y: point.y - 6), radius: 5, startAngle: Double.pi, endAngle: Double.pi * 2, clockwise: true)
            path.addLine(to: CGPoint.init(x: point.x, y: point.y))
            
            self.layer.addSublayer(animationFlagLayer)
        }
        animationFlagLayer.path = path.cgPath

    }
    
    
}

//MARK: touch event
extension BezierCircleStyle2View {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            for (i, p) in levelPoints.enumerated() {
                let frame = CGRect.init(x: p.x - 10, y: p.y - 10, width: 30, height: 30)
                if frame.contains(point) {
                    self.changeAnimationLayer(point: p, at: i)
                    break
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    private func changeAnimationLayer(point: CGPoint, at index: Int) {
        if point.x > scoreWidth {
            animationLayer.strokeColor =  UIColor.hex(0xD8D8D8).cgColor
            animationArrowLayer.fillColor = UIColor.hex(0xD8D8D8).cgColor
        } else {
            animationLayer.strokeColor =  UIColor.hex(0xF9C784).cgColor
            animationArrowLayer.fillColor = UIColor.hex(0xF9C784).cgColor
        }
        animationLayer.frame.origin.x = point.x - 3
        animationArrowLayer.frame.origin.x = point.x - 15
        animationTextLayer.string = "V\(index+1)"


    }
}

