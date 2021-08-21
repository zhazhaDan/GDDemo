//
//  Date+.swift
//  Exchange
//
//  Created by zlc on 2018/11/27.
//  Copyright © 2018 SFG Studio. All rights reserved.
//

import UIKit

extension Date {
    static func getFormatDate(withTs ts: Double, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        DateFormatter.shared.dateFormat = format
        DateFormatter.shared.timeZone = timeZone
        if "\(ts)".count > 10 {
            return DateFormatter.shared.string(from: Date(timeIntervalSince1970: ts*0.001))
        } else {
            return DateFormatter.shared.string(from: Date(timeIntervalSince1970: ts))
        }
    }
    
    static func hoursAndMinutesAndSecondsInOneDay(timeInterval:Int64)->[Int64]{
        let oneDayTime:Int64 = timeInterval%(24*3600)//截取到一天24小时
        let second:Int64 = oneDayTime%60
        let minute:Int64 = oneDayTime/60
        let hour  :Int64 = oneDayTime/3600
        return [hour,minute,second]
    }
    
    static func hoursAndMinutesWithTimeInterval(time:Int64)->String{
        let arr = hoursAndMinutesAndSecondsInOneDay(timeInterval:time)
        var timeString:String = ""
        if (arr[0] > 0) {
            timeString.append("\(arr[0])h")
        }
        if (arr[1] > 0) {
            timeString.append("\(arr[1])min")
        }
        return timeString
    }
    
    ///处理字符串类型:20190521 -> 2019/05/21
    static func format(string: String) -> String {
        let indexStart = string.index(string.startIndex, offsetBy: 4)
        let indexEnd = string.index(string.startIndex, offsetBy: 6)
        let sub = string[indexStart..<indexEnd]
        return string.prefix(4) + "/" + sub + "/" + string.suffix(2)
    }
    
    ///计算当前时间距未来某一天差多少天
    func daysBetween(date: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        let endDate = formatter.date(from: date)
        let components = Calendar.current.dateComponents([.day], from: self, to: endDate!)
        return (components.day!) <= 0 ? 0 : (components.day!)
    }
}

