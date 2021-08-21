//
//  DateCountView.swift
//  GDDemo
//
//  Created by 龚丹丹 on 2019/5/20.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit


class DateCountLabel: UIView {
    
    var lastLabel: UILabel = UILabel()
    var currLabel: UILabel = UILabel()
    
    var duration: Double = 1
    
    var oldText: String?
    var textColor: UIColor! {
        didSet {
            lastLabel.textColor = textColor
            currLabel.textColor = textColor
        }
    }
    
    var font: UIFont! {
        didSet {
            lastLabel.font = font
            currLabel.font = font
        }
    }
    
    var textAlignment: NSTextAlignment! {
        didSet {
            lastLabel.textAlignment = textAlignment
            currLabel.textAlignment = textAlignment
        }
    }
    
    var text: String? {
        willSet {
            lastLabel.text = text
            self.lastLabel.top = 0
            UIView.animate(withDuration: duration, animations: {
                self.lastLabel.bottom = 0
            })
        }
        didSet {
            currLabel.text = text
            self.currLabel.top = self.height
            UIView.animate(withDuration: duration, animations: {
                self.currLabel.top = 0
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func estimateChangeTextFrame() -> CGRect {
        return self.bounds
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.clipsToBounds = true
        self.addSubview(lastLabel)
        lastLabel.frame = self.bounds
        self.addSubview(currLabel)
        currLabel.frame = self.bounds
    }
    

}
