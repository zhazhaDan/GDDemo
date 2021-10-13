//
//  FPSMonitorLabel.swift
//  GDDemo
//
//  Created by GDD on 2021/10/12.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class FPSMonitorLabel: UILabel {
    private var count: NSInteger = 0
    private var lastTime: TimeInterval = 0.0
    private var fpsColor: UIColor = .green
    private var fps: Double = 0.0
    
    private lazy var link: CADisplayLink = {
        let weakTarget = GDProxy.init(target: self, sel: #selector(tick(link:)))
        let v = CADisplayLink.init(target: weakTarget, selector: #selector(tick(link:)))
        v.add(to: RunLoop.current, forMode: .common)
        return v
    }()
    override init(frame: CGRect) {
        if frame.size == .zero {
            super.init(frame: CGRect.init(origin: frame.origin, size: CGSize.init(width: 50, height: 22)))
        } else {
            super.init(frame: frame)
        }
        self.fpsColor = .red
        self.fps = 60
        self.backgroundColor = .black
        self.textColor = .white
        self.textAlignment = .center
        self.font = UIFont.pingFangRegularFont(size: 12)
        self.link.isPaused = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        link.invalidate()
    }
    
    
    @objc func tick(link: CADisplayLink) {
        guard lastTime != 0 else {
            lastTime = link.timestamp
            return
        }
        count += 1
        let delta = link.timestamp - lastTime
        guard delta >= 1.0 else { return }
        lastTime = link.timestamp
        fps = Double(count)/delta
        let fpsText = "\(String.init(format: "%.3f", fps)) FPS"
        count = 0
        
        let attrMsg = NSMutableAttributedString.init(string: fpsText)
        if fps > 55 {
            fpsColor = .green
        } else if fps > 50 {
            fpsColor = .orange
        } else {
            fpsColor = .red
        }
        
        attrMsg.setAttributes([NSAttributedString.Key.foregroundColor : fpsColor], range: NSMakeRange(0, attrMsg.string.count - 3))
        attrMsg.setAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSMakeRange(attrMsg.string.count - 3, 3))
        DispatchQueue.main.async {
            self.attributedText = attrMsg
        }
    }
    
}
