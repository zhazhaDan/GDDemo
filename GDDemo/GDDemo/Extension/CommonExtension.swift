//
//  UIViewExtension.swift
//  Exchange
//
//  Created by GDD on 2018/10/17.
//  Copyright © 2018年 SFG Studio. All rights reserved.
//

import UIKit

/// MARK - UIView
extension UIView {
    // MARK: - 常用位置属性
    public var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }

    public var top:CGFloat {
        get {
            return self.frame.origin.y
        }

        set {
            self.frame.origin.y = newValue
        }
    }

    public var width:CGFloat {
        get {
            return self.frame.size.width
        }

        set {
            self.frame.size.width = newValue
        }
    }

    public var height:CGFloat {
        get {
            return self.frame.size.height
        }

        set {
            self.frame.size.height = newValue
        }
    }

    public var size:CGSize {
        get {
            return self.frame.size
        }
        
        set {
            self.frame.size = newValue
        }
    }
    
    public var right:CGFloat {
        get {
            return self.left + self.width
        }
        
        set {
            self.frame.origin.x = newValue-self.frame.size.width
        }
    }

    public var bottom:CGFloat {
        get {
            return self.top + self.height
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }

    public var centerX:CGFloat {
        get {
            return self.center.x
        }

        set {
            self.center.x = newValue
        }
    }

    public var centerY:CGFloat {
        get {
            return self.center.y
        }

        set {
            self.center.y = newValue
        }
    }
    public var origin:CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
}


