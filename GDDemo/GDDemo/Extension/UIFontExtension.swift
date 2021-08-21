//
//  UIFontExtension.swift
//  Exchange
//
//  Created by GDD on 2018/10/24.
//  Copyright © 2018 SFG Studio. All rights reserved.
//

import UIKit

public enum FontStyle {
    case PingFang_Normal
    case PingFangSC_Medium
    case PingFangSC_Bold
    case Helvetical_Normal
    case Helvetical_Medium
    case Helvetical_Bold
    case DINPro_Medium
    case DINPro_Bold
}



enum TFontName:String {
    case    PingFangFontRegular     =   "PingFangSC-Regular",
            PingFangFontMedium      =   "PingFangSC-Medium",
            PingFangFontSemiBold    =   "PingFangSC-Semibold",
            PingFangFontLight       =   "PingFangSC-Light",
            HelveticaNeueRegular    =   "HelveticaNeue",
            HelveticaNeueMedium     =   "HelveticaNeue-Medium",
            HelveticaNeueBold       =   "HelveticaNeue-Bold",
            DINProMedium            =   "DINPro-Medium",
            DINProBold              =   "DINPro-Bold"
}

extension UIFont {
    class func tFont(fontStyle:TFontName, size:CGFloat) -> UIFont? {
        return UIFont.init(name: fontStyle.rawValue, size: size)
    }
    
    class func pingFangRegularFont(size:CGFloat) -> UIFont? {
        return tFont(fontStyle: .PingFangFontRegular, size: size)
    }
    
    class func pingFangMediumFont(size:CGFloat) -> UIFont? {
        return tFont(fontStyle: .PingFangFontMedium, size: size)
    }
    
    class func pingFangSemiBoldFont(size:CGFloat) -> UIFont? {
        return tFont(fontStyle: .PingFangFontSemiBold, size: size)
    }
    
    class func pingFangLightFont(size: CGFloat) -> UIFont? {
        return tFont(fontStyle: .PingFangFontLight, size: size)
    }
    
    class func helveticaNeueRegularFont(size:CGFloat) -> UIFont? {
        return tFont(fontStyle: .HelveticaNeueRegular, size: size)
    }
    
    class func helveticaNeueMediumFont(size:CGFloat) -> UIFont? {
        return tFont(fontStyle: .HelveticaNeueMedium, size: size)
    }
    
    class func helveticaNeueBoldFont(size:CGFloat) -> UIFont? {
        return tFont(fontStyle: .HelveticaNeueBold, size: size)
    }
    
    class func dinProMediumBoldFont(size:CGFloat) -> UIFont? {
        return tFont(fontStyle: .DINProMedium, size: size)
    }
    
    class func dinProBoldFont(size:CGFloat) -> UIFont? {
        return tFont(fontStyle: .DINProBold, size: size)
    }
    
    class func getFontWithFontStyle(_ fontstyle:FontStyle,fontSize:CGFloat)->UIFont {
        var font:UIFont
        switch (fontstyle) {
        case .PingFang_Normal:
            font = UIFont.pingFangRegularFont(size: fontSize)!
        case .PingFangSC_Medium:
            font = UIFont.pingFangMediumFont(size: fontSize)!
        case .PingFangSC_Bold:
            font = UIFont.pingFangSemiBoldFont(size: fontSize)!
        case .Helvetical_Normal:
            font = UIFont.helveticaNeueRegularFont(size: fontSize)!
        case .Helvetical_Medium:
            font = UIFont.helveticaNeueMediumFont(size: fontSize)!
        case .Helvetical_Bold:
            font = UIFont.helveticaNeueBoldFont(size: fontSize)!
        case .DINPro_Medium:
            font = UIFont.dinProMediumBoldFont(size: fontSize)!
        case .DINPro_Bold:
            font = UIFont.dinProBoldFont(size: fontSize)!
        default:
            font = UIFont.pingFangRegularFont(size: fontSize)!
        }
        return font
    }
    
}
