//
//  DateCountView.swift
//  GDDemo
//
//  Created by 龚丹丹 on 2019/5/20.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit


enum AutoScrollLabelAnimateType {
    case none, partAuto, allAuto
}


class AutoScrollLabel: UILabel {
    
    private var lastLabel: UILabel = UILabel()
    private var currLabel: UILabel = UILabel()
    private var immutableLabel: UILabel = UILabel()

    public var animateType: AutoScrollLabelAnimateType = .none
    
    var duration: Double = 1
    var partAnimation: Bool = false
    
    override var textColor: UIColor! {
        didSet {
            [lastLabel, currLabel, immutableLabel].forEach{
                $0.textColor = textColor
            }
        }
    }
    
    override var font: UIFont! {
        didSet {
            [lastLabel, currLabel, immutableLabel].forEach{
                $0.font = font
            }
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            [lastLabel, currLabel, immutableLabel].forEach{
                $0.textAlignment = textAlignment
            }
        }
    }
    
    
    override var backgroundColor: UIColor? {
        didSet {
            [lastLabel, currLabel, immutableLabel].forEach{
                $0.backgroundColor = backgroundColor
            }
        }
    }
    
    override var text: String? {
        didSet {
            textChange(oldValue: oldValue, newValue: text)
            commitAnimate()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
    private func textChange(oldValue: String?, newValue: String?) {
        switch animateType {
        case .none:
            self.immutableLabel.text = newValue
        case .allAuto:
            lastLabel.text = oldValue
            currLabel.text = text
        case .partAuto:
            compara(oldValue: oldValue, newValue: newValue)
            
        default:
            break
        }
    }
    
   
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.clipsToBounds = true
        [immutableLabel, lastLabel, currLabel].forEach({
            $0.frame = self.bounds
            self.addSubview($0)
        })
    }
    
    override func drawText(in rect: CGRect) { }
    

}

// 数字变化动画1
extension AutoScrollLabel {
    private func animateAutoScrollAnimate() {
        self.lastLabel.top = 0
        UIView.animate(withDuration: duration, animations: {
            self.lastLabel.bottom = 0
        })
        self.currLabel.top = self.height
        UIView.animate(withDuration: duration, animations: {
            self.currLabel.top = 0
        })
    }
    
    private func compara(oldValue: String?, newValue: String?)  {
        var index: Int = 0
        self.immutableLabel.text = newValue
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
            immutableLabel.text = old.mySubString(to: index)
            lastLabel.text = old.mySubString(from: index)
            currLabel.text = new.mySubString(from: index)
            [immutableLabel, lastLabel, currLabel].forEach({
                $0.sizeToFit()
                $0.height = self.height
            })
            lastLabel.left = immutableLabel.right
            currLabel.left = immutableLabel.right
        }
        
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
