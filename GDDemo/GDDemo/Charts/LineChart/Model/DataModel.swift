//
//  DataModel.swift
//  GDDemo
//
//  Created by 龚丹丹 on 2019/3/17.
//  Copyright © 2019 GDD. All rights reserved.
//

import UIKit

class DataModel: NSObject {
    var time:Int64!//时间
    var price:Double! //波动单价
    var turnOver:Int64! //成交量
    var isStep:Bool = false //是否是插入点
    /// shadow-high value
    @objc open var high = Double(0.0)
    
    /// shadow-low value
    @objc open var low = Double(0.0)
    
    /// close value
    @objc open var close = Double(0.0)
    
    /// open value
    @objc open var open = Double(0.0)
    
    init(time: Int64 , price: Double, turnOver: Int64, isStep:Bool) {
        self.time = time
        self.price = price
        self.turnOver = turnOver
        self.isStep = isStep
    }
    
    init(time: Int64 , high: Double, low: Double, close:Double, open:Double, turnOver: Int64) {
        self.time = time
        self.high = high
        self.low = high
        self.close = close
        self.open = open
        self.turnOver = turnOver
    }
}
