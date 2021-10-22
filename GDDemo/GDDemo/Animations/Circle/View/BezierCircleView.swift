//
//  BezierCircleView.swift
//  GDDemo
//
//  Created by GDD on 2021/10/22.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class BezierCircleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopTimer()
    }
    private var colorLayer: CAShapeLayer!
    private var gradientLayer: CAGradientLayer!
    private var animationLayer: CAShapeLayer!
    private var timer: Timer?
    private var animatEnd = false
    private var levelPoints:[CGPoint] = []
}

//MARK: timer
extension BezierCircleView {
    @objc func animate() {
        if animatEnd, colorLayer.strokeEnd > 0 {
            colorLayer.strokeEnd -= 0.01
            return
        }
        
        if colorLayer.strokeEnd < 1 {
            colorLayer.strokeEnd += 0.01
            animatEnd = false
        } else {
            animatEnd = true
        }
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func startTimer() {
        stopTimer()
        let proxy = GDProxy.init(target: self, sel: #selector(animate))
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: proxy, selector: #selector(animate), userInfo: nil, repeats: true)
    }
}

extension BezierCircleView {
    func setupUI() {
        let pathCenter = CGPoint.init(x: self.width/2, y: self.height/2)
        let path = UIBezierPath.init(arcCenter: pathCenter, radius: 118, startAngle: Double.pi, endAngle: Double.pi * 2, clockwise: true)
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.strokeColor =  UIColor.brown.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 4
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.lineCap = .round
        layer.path = path.cgPath
        self.layer.addSublayer(layer)
        
        
        let colorPath = UIBezierPath.init(arcCenter: pathCenter, radius: 118, startAngle: Double.pi, endAngle: Double.pi * 1.5, clockwise: true)
        self.colorLayer = CAShapeLayer()
        colorLayer.frame = self.bounds
        colorLayer.strokeColor =  UIColor.orange.cgColor
        colorLayer.fillColor = UIColor.clear.cgColor
        colorLayer.lineWidth = 10
        colorLayer.strokeStart = 0
        colorLayer.strokeEnd = 1
        colorLayer.lineCap = .round
        colorLayer.path = colorPath.cgPath
        self.layer.addSublayer(colorLayer)
        
        self.gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
        gradientLayer.locations = [0, 0.5]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        gradientLayer.mask = colorLayer
        self.layer.addSublayer(gradientLayer)
        
        
        levelPoints.removeAll()
        for i in 0..<8 {
            let point = calcCircleCoordinate(center: pathCenter, angle: Double.pi + Double.pi/7 * Double(i), radius: 118)
            levelPoints.append(point)
            let dotPath = UIBezierPath.init(arcCenter: point, radius: 5, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
            let dotLayer = CAShapeLayer()
            dotLayer.frame = self.bounds//CGRect.init(x: point.x - 5, y: point.y - 5, width: 10, height: 10)
            dotLayer.strokeColor =  UIColor.green.cgColor
            dotLayer.fillColor = UIColor.white.cgColor
            dotLayer.lineWidth = 2
            dotLayer.strokeStart = 0
            dotLayer.strokeEnd = 1
            dotLayer.lineCap = .round
            dotLayer.path = dotPath.cgPath
            self.layer.addSublayer(dotLayer)
        }
        let point = calcCircleCoordinate(center: pathCenter, angle: Double.pi, radius: 118)
        let animatPath = UIBezierPath.init(arcCenter: point, radius: 10, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
        animationLayer = CAShapeLayer()
        animationLayer.frame = self.bounds
        animationLayer.strokeColor =  UIColor.orange.cgColor
        animationLayer.fillColor = UIColor.white.cgColor
        animationLayer.lineWidth = 5
        animationLayer.strokeStart = 0
        animationLayer.strokeEnd = 1
        animationLayer.lineCap = .round
        animationLayer.path = animatPath.cgPath
        animationLayer.position = pathCenter
        self.layer.addSublayer(animationLayer)
        
    }
    
    private func calcCircleCoordinate(center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
        let x = radius * CGFloat(cosf(Float(angle)))
        let y = radius * CGFloat(sinf(Float(angle)))
        return CGPoint.init(x: center.x + x, y: center.y + y)
    }
    
    
    
    
}

//MARK: touch event
extension BezierCircleView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            for p in levelPoints {
                let frame = CGRect.init(x: p.x - 10, y: p.y - 10, width: 30, height: 30)
                if frame.contains(point) {
                    self.changeAnimationLayer(point: p)
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
    
    private func changeAnimationLayer(point: CGPoint) {
        let animatPath = UIBezierPath.init(arcCenter: point, radius: 10, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
        animationLayer.path = animatPath.cgPath
    }
}
