//
//  THChartHighlightShowView.swift
//  GDDemo
//
//  Created by GDD on 2019/3/18.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit

enum ArrayStyle {
    case left,right,none
}

class THChartHighlightShowView: UIView {

    private let arrowWidth:CGFloat = 10
    private var textLabel:UILabel = UILabel()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       drawBackPath().stroke()
    }
    
    private func drawBackPath() -> UIBezierPath{
        let path = UIBezierPath()
        drawArrow(path: path)
        path.lineWidth = 0.5
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        UIColor.white.set()
        UIColor.white.setStroke()
        return path
    }
    
    private func drawArrow(path:UIBezierPath) {
        switch arrowStyle {
        case .none:
            normalRectPath(path: path)
        case .left:
            leftArrowPath(path: path)
        case .right:
            rightArrowPath(path: path)
        }
    }
    
    private func rightArrowPath(path:UIBezierPath) {
        path.move(to: CGPoint.init(x: 0, y: 0))//1
        path.addLine(to: CGPoint.init(x: 0, y: self.height))//2
        path.addLine(to: CGPoint.init(x: self.width - arrowWidth, y: self.height))//3
        path.addLine(to: CGPoint.init(x: self.width, y: self.height/2.0))//4
        path.addLine(to: CGPoint.init(x: self.width - arrowWidth, y: 0))//5
        path.addLine(to: CGPoint.init(x: 0, y: 0))//6
    }
    
    private func leftArrowPath(path:UIBezierPath) {
        path.move(to: CGPoint.init(x: arrowWidth, y: 0))//1
        path.addLine(to: CGPoint.init(x: 0, y: self.height/2.0))//2
        path.addLine(to: CGPoint.init(x: arrowWidth, y: self.height))//3
        path.addLine(to: CGPoint.init(x: self.width, y: self.height))//4
        path.addLine(to: CGPoint.init(x: self.width, y: 0))//5
        path.addLine(to: CGPoint.init(x: arrowWidth, y: 0))//6

    }
    
    private func normalRectPath(path:UIBezierPath) {
        path.move(to: CGPoint.init(x: 0, y: 0))//1
        path.addLine(to: CGPoint.init(x: 0, y: self.height))//2
        path.addLine(to: CGPoint.init(x: self.width, y: self.height))//3
        path.addLine(to: CGPoint.init(x: self.width, y: 0))//4
        path.move(to: CGPoint.init(x: 0, y: 0))//5
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(textLabel.then({
//            $0.custom(color: UIColor.white, fontSize: 9, fontstyle: FontStyle.Helvetical_Normal, align: .center)
//        }))
        self.backgroundColor = UIColor.clear
        addSubview(textLabel)
        textLabel.font = UIFont.pingFangRegularFont(size: 12)
        textLabel.textColor = UIColor.white
        textLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 3, left: 3, bottom: 3, right: 3))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var text: String? {
        didSet{
            textLabel.text = text
        }
    }
    var arrowStyle:ArrayStyle = .none {
        didSet {
            self.setNeedsDisplay()
            textLabel.snp.remakeConstraints { (make) in
                switch arrowStyle {
                case .none:
                    make.edges.equalTo(UIEdgeInsets.init(top: 3, left: 3, bottom: 3, right: 3))
                case .left:
                    make.edges.equalTo(UIEdgeInsets.init(top: 3, left: 13, bottom: 3, right: 3))
                case .right:
                    make.edges.equalTo(UIEdgeInsets.init(top: 3, left: 3, bottom: 3, right: 13))
                }
            }
        }
    }

}
