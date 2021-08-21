//
//  ChartHighLightView.swift
//  GDDemo
//
//  Created by GDD on 2019/3/18.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit

class THChartHighLightView: UIView {
    private var horLineView:UIView = UIView()
    private var verLineView:UIView = UIView()
    private var horShowTextView:THChartHighlightShowView = THChartHighlightShowView()
    private var verShowTextView:THChartHighlightShowView = THChartHighlightShowView()
    public var highlightIcon:UIImage = UIImage.init(named: "binary_chart_point")! {
        didSet {
            highlightView.image = highlightIcon
        }
    }
    private var highlightView:UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(){
        
        addSubview(horLineView)
        addSubview(verLineView)
        addSubview(verShowTextView)
        addSubview(horShowTextView)
        addSubview(highlightView)

        highlightView.backgroundColor = UIColor.white
        highlightView.layer.cornerRadius = 2.5
        highlightView.layer.masksToBounds = true
        highlightView.image = highlightIcon
        
        highlightView.snp.makeConstraints({
            $0.size.equalTo(CGSize.init(width: 5, height: 5))
            $0.center.equalTo(CGPoint.zero)
        })
        
        horLineView.backgroundColor = UIColor.white
        horLineView.snp.makeConstraints({
            $0.right.equalTo(horShowTextView.snp.left)
            $0.left.equalTo(horShowTextView.snp.left)
            $0.height.equalTo(0.5)
            $0.centerY.equalTo(highlightView)
        })
        
        verLineView.backgroundColor = UIColor.white
        verLineView.snp.makeConstraints({
            $0.top.equalTo(0)
            $0.bottom.equalTo(verShowTextView.snp.top)
            $0.width.equalTo(0.5)
            $0.centerX.equalTo(highlightView)
        })
        
        verShowTextView.arrowStyle = .none
        verShowTextView.layer.borderColor = UIColor.white.cgColor
        verShowTextView.layer.borderWidth = 0.5
        verShowTextView.snp.makeConstraints({
            $0.bottom.equalToSuperview()
            $0.height.equalTo(20)
            $0.centerX.equalTo(verLineView)
        })
        horShowTextView.arrowStyle = .left
        horShowTextView.snp.makeConstraints({
            $0.right.equalToSuperview()
            $0.left.equalToSuperview()
            $0.centerX.equalTo(horLineView)
            $0.size.equalTo(CGSize.zero)
        })
        
    }
    
    public func update(centerPosition:CGPoint, horText:String, verText:String) {
        highlightView.snp.updateConstraints({
            $0.center.equalTo(centerPosition)
        })
        verShowTextView.text = verText
        horShowTextView.text = horText
        if  centerPosition.x < self.width/2 {
            horShowTextView.arrowStyle = .right
            horShowTextView.snp.remakeConstraints({
                $0.left.equalToSuperview()
                $0.centerY.equalTo(horLineView)
            })
            horLineView.snp.remakeConstraints({
                $0.right.equalToSuperview()
                $0.left.equalTo(horShowTextView.snp.right)
                $0.height.equalTo(0.5)
                $0.centerY.equalTo(highlightView)
            })
        }else {
            horShowTextView.arrowStyle = .left
            horShowTextView.snp.remakeConstraints({
                $0.right.equalToSuperview()
                $0.centerY.equalTo(horLineView)
            })
            horLineView.snp.remakeConstraints({
                $0.right.equalTo(horShowTextView.snp.left)
                $0.left.equalToSuperview()
                $0.height.equalTo(0.5)
                $0.centerY.equalTo(highlightView)
            })
        }
    }
    
}
