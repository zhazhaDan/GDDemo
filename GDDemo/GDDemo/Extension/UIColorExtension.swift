//
//  UIColorExtension.swift
//  Exchange
//
//  Created by GDD on 2018/10/24.
//  Copyright © 2018 SFG Studio. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    public var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }
    
    class func hex(_ hex:Int, alpha:CGFloat = 1.0) -> (UIColor) {
        return UIColor(hex: hex, alpha: alpha)
    }
    
    class func rgb(_ r:UInt8 = 255,
                   _ g:UInt8 = 255,
                   _ b:UInt8 = 255,
                   _ a:CGFloat = 1.0) -> (UIColor){
        
        let R = CGFloat(r) / 255.0
        let G = CGFloat(g) / 255.0
        let B = CGFloat(b) / 255.0
        
        return UIColor(red:R, green:G, blue:B, alpha:a)
    }
    
    convenience init(hex:Int, alpha:CGFloat = 1) {
        let r = Int(hex&0xFF0000) >> 16
        let g = Int(hex&0xFF00) >> 8
        let b = Int(hex&0xFF)

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
