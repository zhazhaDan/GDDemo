//
//  AutoScrollLabel1.swift
//  GDDemo
//
//  Created by 龚丹丹 on 2019/5/24.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit

class AutoScrollLabel1: UILabel {

  
    public var animateType: AutoScrollLabelAnimateType = .none
    private var lastLabelLayer: GDTextLayer = GDTextLayer()
    private var currLabelLayer: GDTextLayer = GDTextLayer()
    private var immutableLabelLayer: GDTextLayer = GDTextLayer()
    
    var duration: Double = 1
    
    override var textColor: UIColor! {
        didSet {
            [lastLabelLayer, currLabelLayer, immutableLabelLayer].forEach{
                $0.foregroundColor = textColor.cgColor
            }
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            [lastLabelLayer, currLabelLayer, immutableLabelLayer].forEach{
                $0.backgroundColor = backgroundColor?.cgColor
            }
        }
    }
    
    override var font: UIFont! {
        didSet {
            [lastLabelLayer, currLabelLayer, immutableLabelLayer].forEach{
                $0.font = font
                $0.fontSize = font.pointSize
                $0.contentsScale = UIScreen.main.scale
            }
        }
    }
    
    override var text: String? {
        didSet {
            commitAnimate()
            textChange(oldValue: oldValue, newValue: text)
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            [lastLabelLayer, currLabelLayer, immutableLabelLayer].forEach{
                switch textAlignment {
                case .center:
                    $0.alignmentMode = .center
                case .left:
                    $0.alignmentMode = .left
                case .right:
                    $0.alignmentMode = .right
                case .justified:
                    $0.alignmentMode = .justified
                case .natural:
                    $0.alignmentMode = .natural
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func textChange(oldValue: String?, newValue: String?) {
        
        switch animateType {
        case .none:
            self.lastLabelLayer.string = text
            break
        case .partAuto:
            compara(oldValue: oldValue, newValue: newValue)
            break
        case .allAuto:
            lastLabelLayer.string = oldValue
            currLabelLayer.string = text
        default:
            break
        }
    }
    
    func commitAnimate() {
        switch animateType {
        case .none:
            break
        case .partAuto, .allAuto:
            animateAutoScrollAnimate()
        default:
            break
        }
    }
    
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.clipsToBounds = true
        [lastLabelLayer, currLabelLayer, immutableLabelLayer].forEach({
            $0.frame = self.bounds
            self.layer.addSublayer($0)
        })
    }
    

    override func drawText(in rect: CGRect) {}

}


extension AutoScrollLabel1 {
    private func animateAutoScrollAnimate() {
        let keypath = "anchorPoint.y"
        let animateKey1 = "animation1"

        let animate1 = CABasicAnimation()
        animate1.keyPath = keypath
        animate1.fillMode = .forwards
        animate1.repeatCount = 1
        animate1.isRemovedOnCompletion = false
        animate1.fromValue = 0.5
        animate1.toValue = 1.2
        animate1.delegate = self
        animate1.duration = duration*0.5
        self.lastLabelLayer.add(animate1, forKey: animateKey1)
        
        let animateKey2 = "animation2"
        let animate2 = CABasicAnimation()
        animate2.keyPath = keypath
        animate2.fillMode = .forwards
        animate2.repeatCount = 1
        animate2.isRemovedOnCompletion = false
        animate2.fromValue = -0.2
        animate2.toValue = 0.5
        animate2.delegate = self
        animate2.duration = duration*0.5
        self.currLabelLayer.add(animate2, forKey: animateKey2)
    
    }
    
    
    
    private func compara(oldValue: String?, newValue: String?)  {
        var index: Int = 0
        self.immutableLabelLayer.string = newValue
        if let old = oldValue, let new = newValue {
            let oldArray = Array(old)
            let newArray = Array(new)
            let text = old.count > new.count ? new : old
            for i in 0..<text.count {
                if oldArray[i] != newArray[i] {
                    index = i
                    break
                }
            }
            
            let immText = old.mySubString(to: index)
            let oldText = old.mySubString(from: index)
            let newText = new.mySubString(from: index)
            
            
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            //新赋值
            immutableLabelLayer.string = immText
            lastLabelLayer.string = oldText
            currLabelLayer.string = newText

            var textWidth = immText.boundingRect(with: CGSize(width: 375,height: frame.size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size.width
            immutableLabelLayer.frame = CGRect(x: 0, y: 0, width: textWidth , height: self.height)
            
            textWidth = oldText.boundingRect(with: CGSize(width: 375,height: frame.size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size.width
            lastLabelLayer.frame.size.width = textWidth
            lastLabelLayer.frame.origin.x = immutableLabelLayer.frame.width + immutableLabelLayer.frame.origin.x
            
            textWidth = newText.boundingRect(with: CGSize(width: 375,height: frame.size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size.width
            currLabelLayer.frame.size.width = textWidth
            currLabelLayer.frame.origin.x = immutableLabelLayer.frame.width + immutableLabelLayer.frame.origin.x
            CATransaction.commit()
        }
    }
    
}

extension AutoScrollLabel1: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            //重置锚点
            lastLabelLayer.string = currLabelLayer.string
            lastLabelLayer.anchorPoint.y = 0.5
            currLabelLayer.anchorPoint.y = -0.2
        }
    }
}



class GDTextLayer: CATextLayer {
    override func draw(in ctx: CGContext) {
        let height = self.bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height - fontSize)/2.0 - fontSize/5.0
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
    
    func resumAnimate() {
        let pausedTime = timeOffset
        speed = 1
        timeOffset = 0
        beginTime = 0
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
}

private extension String {
    func mySubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func mySubString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
}
