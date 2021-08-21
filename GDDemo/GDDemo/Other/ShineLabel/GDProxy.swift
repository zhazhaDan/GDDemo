//
//  GDProxy.swift
//  GDDemo
//
//  Created by GDD on 2021/8/8.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class GDProxy: NSObject {
    weak var target: NSObjectProtocol?
    var sel: Selector?


    public convenience init(target: NSObjectProtocol?, sel: Selector?) {
        self.init()
        self.sel = sel
        self.target = target
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return self.target
    }
    // NSObject 一些方法复写

        override func isEqual(_ object: Any?) -> Bool {
            return target?.isEqual(object) ?? false
        }

        override var hash: Int{
            return target?.hash ?? -1
        }

        override var superclass: AnyClass?{
            return target?.superclass ?? nil
        }
    
        override func isProxy() -> Bool {
            return true
        }

        override func isKind(of aClass: AnyClass) -> Bool {
            return target?.isKind(of: aClass) ?? false
        }

        override func isMember(of aClass: AnyClass) -> Bool {
            return target?.isMember(of: aClass) ?? false
        }

        override func conforms(to aProtocol: Protocol) -> Bool {
            return  target?.conforms(to: aProtocol) ?? false
        }

        override func responds(to aSelector: Selector!) -> Bool {
            return target?.responds(to: aSelector) ?? false
        }

        override var description: String{
            return target?.description ?? "nil"
        }

        override var debugDescription: String{
            return target?.debugDescription ?? "nil"
        }

        deinit {
            print("Proxy释放了")
        }
}
