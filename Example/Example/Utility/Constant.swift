//
//  Constant.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//

import UIKit

// MARK: - Constant
final class Constant: NSObject {}

// MARK: - enum
extension Constant {
    
    /// [時間的格式](https://nsdateformatter.com)
    enum DateFormat: CustomStringConvertible {
        
        var description: String { return toString() }
        
        case full
        case long
        case middle
        case meridiem(formatLocale: Locale)
        case short
        case timeZone
        case time
        case yearMonth
        case monthDay
        case day
        case web
        case custom(format: String)
        
        /// [轉成對應的字串](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/dateformatter-的-am-pm-問題-5e0d301e8998)
        private func toString() -> String {
            
            switch self {
            case .full: return "yyyy-MM-dd HH:mm:ss ZZZ"
            case .long: return "yyyy-MM-dd HH:mm:ss"
            case .middle: return "yyyy-MM-dd HH:mm"
            case .meridiem: return "yyyy-MM-dd hh:mm a"
            case .short: return "yyyy-MM-dd"
            case .timeZone: return "ZZZ"
            case .time: return "HH:mm:ss"
            case .yearMonth: return "yyyy-MM"
            case .monthDay: return "MM-dd"
            case .day: return "dd"
            case .web: return "E, dd MM yyyy hh:mm:ss ZZZ"
            case .custom(let format): return format
            }
        }
    }
}
