//
//  ShineLabel.swift
//  GDDemo
//
//  Created by GDD on 2021/8/8.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit


typealias DisplayCallback = (() -> Void)
class ShineLabel: UILabel {



    private lazy var displayLink: CADisplayLink = {
        let weakTarget = GDProxy.init(target: self, sel: #selector(linkStep))
        let v = CADisplayLink.init(target: weakTarget, selector: #selector(linkStep))
        v.add(to: RunLoop.current, forMode: .common)
        return v
    }()

    private var startTime: CFTimeInterval = 0
    private var endTime: CFTimeInterval = 0
    private var characterAnimationDelays: [CFTimeInterval] = []
    private var characterAnimationDurations: [CFTimeInterval] = []
    private var characterShineDuration: CFTimeInterval = 2.5
    private var _attributedString: NSMutableAttributedString?
    private var completion: DisplayCallback?

// public
    var autoAnimation: Bool = false

    var animating: Bool {
        return !self.displayLink.isPaused
    }

    enum AnimationStyle {
        case fadeOut, `default`
    }
    var animationStyle: AnimationStyle = .default

    override var text: String? {
        didSet {
            guard let text = text else { return }
            self.attributedText = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.foregroundColor : textColor])
        }
    }

    override var attributedText: NSAttributedString? {
        set {
            guard let attText = newValue else { return }
            let color = textColor.withAlphaComponent(0)
            _attributedString = NSMutableAttributedString.init(string: attText.string, attributes: [NSAttributedString.Key.foregroundColor : color])
            super.attributedText = _attributedString
            self.handleStringAnimationTime()
        }

        get {
            return _attributedString
        }
    }


    override func didMoveToWindow() {
        if let _ = self.window, autoAnimation {
            self.shine()
        }
    }

    deinit {
        self.displayLink.invalidate()
    }

}

extension ShineLabel {
    func shine() {
        startAnimation(duration: self.characterShineDuration)
    }

    private func startAnimation(duration: CFTimeInterval) {
        self.startAnimation(duration: duration, nil)
    }

    func fadeOutAnimation(duration: CFTimeInterval, _ completion: DisplayCallback? = nil) {
        self.animationStyle = .fadeOut
        self.startAnimation(duration: duration, completion)
    }

    private func startAnimation(duration: CFTimeInterval, _ completion: DisplayCallback? = nil) {
        self.completion = completion
        self.startTime = CACurrentMediaTime()
        self.endTime = self.startTime + duration
        self.displayLink.isPaused = false
    }
}


extension ShineLabel {

    private func handleStringAnimationTime() {
        if characterAnimationDelays.count != _attributedString?.string.count {
            characterAnimationDelays = Array.init(repeating: 0, count: _attributedString?.string.count ?? 0)
            characterAnimationDurations = Array.init(repeating: 0, count: _attributedString?.string.count ?? 0)
        }
        for i in 0..<_attributedString!.string.count {
            characterAnimationDelays[i] = CFTimeInterval(arc4random_uniform(UInt32(characterShineDuration/2 * 100)))/100
            let remain = self.characterShineDuration - self.characterAnimationDelays[i]
            characterAnimationDurations[i] = CFTimeInterval(arc4random_uniform(UInt32(remain * 100)))/100
        }
    }

    @objc private func linkStep() {
        guard let attrText = self.attributedText else { return }
        let now = CACurrentMediaTime()
        for i in 0..<attrText.string.count {
//            if attrText.string[i].isWhitespace {
//                return
//            }
            attrText.enumerateAttribute(.foregroundColor, in: NSMakeRange(i, 1), options: .longestEffectiveRangeNotRequired) { value, range, stop in
                guard let color = value as? UIColor else { return }
                let currentAlpha = color.cgColor.alpha
                let shouldUpdateAlpha = currentAlpha > 0 || (now - startTime) >= self.characterAnimationDelays[i]
                if !shouldUpdateAlpha { return }

                var percentage = (now - startTime - characterAnimationDelays[i]) / characterAnimationDurations[i]
                if animationStyle == .fadeOut {
                    percentage = 1 - percentage
                }
                let tColor = textColor.withAlphaComponent(CGFloat(percentage))
                _attributedString?.addAttribute(NSAttributedString.Key.foregroundColor, value: tColor, range: range)
            }

        }
        super.attributedText = _attributedString
        if now > endTime {
            self.displayLink.isPaused = true
            self.handleStringAnimationTime()
            self.completion?()
        }
    }
}

extension String {
    subscript (_ i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
