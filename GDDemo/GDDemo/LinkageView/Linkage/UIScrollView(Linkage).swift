//
//  UIScrollView(Linkage).swift
//  GDDemo
//
//  Created by GDD on 2020/10/28.
//  Copyright © 2020 GDD. All rights reserved.
//

import Foundation
import UIKit

private var LinkageScrollViewArriveTopKey = "LinkageScrollViewArriveTopKey"

extension UIScrollView {
    var arriveTop: Bool {
        set {
            objc_setAssociatedObject(self, &LinkageScrollViewArriveTopKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let value = objc_getAssociatedObject(self, &LinkageScrollViewArriveTopKey) as? Bool {
                return value
            } else {
                self.arriveTop = true
                return true
            }
        }
    }
}
