//
//  BezierCircleStyle3View.swift
//  GDDemo
//
//  Created by GDD on 2021/10/25.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class BezierCircleStyle3View: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var colorLayer: CAShapeLayer!
//    private var levelPoints:[CGPoint] = []
    private var levelScores:[Int] = [0, 2000, 6000, 15000, 30000, 42000, 56000, 72000]
    private var animationLayer: CAShapeLayer!
    private var score: Int = 63000
    private var scoreLevel: Int = 1
    private var scoreWidth: Double = 0
    private var scoreStartX: Double = 0
    private var animationFlagLayer: CAShapeLayer!
    private var scoreLineMaxWidth: Double = 0
}


extension BezierCircleStyle3View {
    func setupUI() {
        let baseLinePath = UIBezierPath()
        baseLinePath.move(to: CGPoint.init(x: 0, y: self.height/2))
        baseLinePath.addLine(to: CGPoint.init(x: self.width, y: self.height/2))
        let baseLineLayer = CAShapeLayer()
        baseLineLayer.frame = self.bounds
        baseLineLayer.strokeColor =  UIColor.white.cgColor
        baseLineLayer.fillColor = UIColor.clear.cgColor
        baseLineLayer.lineWidth = 2
        baseLineLayer.strokeStart = 0
        baseLineLayer.strokeEnd = 1
        baseLineLayer.lineCap = .round
        baseLineLayer.path = baseLinePath.cgPath
        self.layer.addSublayer(baseLineLayer)
        
        let colorLinePath = UIBezierPath()
        colorLinePath.move(to: CGPoint.init(x: 0, y: self.height/2))
        self.calcScoreWidth()
        colorLinePath.addLine(to: CGPoint.init(x: scoreWidth + scoreStartX, y: self.height/2))
        colorLayer = CAShapeLayer()
        colorLayer.frame = self.bounds
        colorLayer.strokeColor = UIColor.hex(0x6B420B).cgColor
        colorLayer.fillColor = UIColor.clear.cgColor
        colorLayer.lineWidth = 2
        colorLayer.strokeStart = 0
        colorLayer.strokeEnd = 1
        colorLayer.lineCap = .round
        colorLayer.path = colorLinePath.cgPath
        self.layer.addSublayer(colorLayer)
       
        
        for i in 0..<3 {
            var point = CGPoint.init(x: self.scoreLineMaxWidth/3*Double(i), y: self.height/2)
            if i == 2 {
                point.x = scoreLineMaxWidth
            }
            point.x += scoreStartX
            let dotPath = UIBezierPath.init(arcCenter: point, radius: 2, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
            let dotLayer = CAShapeLayer()
            dotLayer.frame = self.bounds
            if point.x > scoreWidth + scoreStartX {
                dotLayer.strokeColor = UIColor.white.cgColor
                dotLayer.fillColor = UIColor.white.cgColor
            } else {
                dotLayer.strokeColor = UIColor.hex(0x6B420B).cgColor
                dotLayer.fillColor = UIColor.hex(0x6B420B).cgColor
            }
            dotLayer.lineWidth = 2
            dotLayer.strokeStart = 0
            dotLayer.strokeEnd = 1
            dotLayer.lineCap = .round
            dotLayer.path = dotPath.cgPath
            self.layer.addSublayer(dotLayer)
            
           
            var string = "V\(scoreLevel + i - 1)"
            if scoreLevel <= 1 {
                string = "V\(scoreLevel + i)"
            }
            let textLayer = CATextLayer()
            textLayer.string = string
            let size = CGSize.init(width: 20, height: 20)
            textLayer.frame.size = size
            textLayer.frame.origin = CGPoint.init(x: point.x - size.width/2, y: point.y + 13)
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.fontSize = 14
            if point.x > scoreWidth + scoreStartX {
                textLayer.foregroundColor =  UIColor.white.cgColor
            } else {
                textLayer.foregroundColor =  UIColor.hex(0x6B420B).cgColor
            }
            self.layer.addSublayer(textLayer)

        }
        
        drawFlagLayer(point: CGPoint.init(x: scoreWidth + scoreStartX, y: self.height/2))
    }
    
    func calcScoreWidth() {
        for (i, standard) in levelScores.enumerated() {
            if score > standard {
                scoreLevel = i + 1
            }
        }
        scoreLineMaxWidth = self.width * 0.8
        if scoreLevel > 1 {
            if scoreLevel == 7 {
                scoreLineMaxWidth = self.width * 0.9
            } else if scoreLevel < 3 {
                scoreLineMaxWidth = self.width * 0.9
            }
            let diff = levelScores[scoreLevel] - levelScores[scoreLevel - 1]
            scoreWidth = scoreLineMaxWidth / 3 + (Double(score) - Double(levelScores[scoreLevel - 1])) / Double(diff) * scoreLineMaxWidth / 3 * 2
        } else {
            scoreLineMaxWidth = self.width * 0.9
            scoreWidth = Double(score) / Double(levelScores[1]) * scoreLineMaxWidth / 3
        }
        if scoreLevel >= 3 {
            scoreStartX = self.width * 0.1
        } else {
            scoreStartX = 0
        }
        
    }
    
   
    func drawFlagLayer(point: CGPoint) {
        let path = UIBezierPath()

        if animationFlagLayer == nil {
            animationFlagLayer = CAShapeLayer()
            let frame = CGRect.init(x: point.x - 5, y: point.y - 16, width: 10, height: 12)
            animationFlagLayer.frame = frame
            animationFlagLayer.strokeStart = 0
            animationFlagLayer.strokeEnd = 1
            animationFlagLayer.fillColor = UIColor.hex(0x6B420B).cgColor
            let point = CGPoint.init(x: 0, y: 5)
            path.move(to: CGPoint.init(x: point.x, y: point.y))
            path.addArc(withCenter: CGPoint.init(x: 5, y: point.y), radius: 5, startAngle: Double.pi, endAngle: Double.pi * 2, clockwise: true)
            path.addQuadCurve(to: CGPoint.init(x: 5, y: 12), controlPoint: CGPoint.init(x: 10, y: point.y + 2))
            path.addQuadCurve(to: CGPoint.init(x: point.x, y: point.y), controlPoint: CGPoint.init(x: point.x, y: point.y + 2))
            self.layer.addSublayer(animationFlagLayer)
        }
        animationFlagLayer.path = path.cgPath

    }
    
    
}
