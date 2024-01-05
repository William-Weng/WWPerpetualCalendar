//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//

import UIKit
import WWPerpetualCalendar

// MARK: - Collection (override class function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}

// MARK: - Date (function)
extension Date {
    
    /// [增加日期 => 年 / 月 / 日](https://areckkimo.medium.com/用uipageviewcontroller實作萬年曆-76edaac841e1)
    /// - Parameters:
    ///   - component:
    ///   - value: 年(.year) / 月(.month) / 日(.day)
    ///   - calendar: 當地的日曆基準
    /// - Returns: Date?
    func _adding(component: Calendar.Component = .day, value: Int, for calendar: Calendar = .current) -> Date? {
        return calendar.date(byAdding: component, value: value, to: self)
    }
    
    /// 將UTC時間 => 該時區的時間
    /// - 2020-07-07 16:08:50 +0800
    /// - Parameters:
    ///   - dateFormat: 時間格式
    ///   - timeZone: 時區
    /// - Returns: String?
    func _localTime(with dateFormat: Constant.DateFormat = .full, timeZone: TimeZone = .current) -> String? {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "\(dateFormat)"
        dateFormatter.timeZone = timeZone
        
        switch dateFormat {
        case .meridiem(formatLocale: let locale): dateFormatter.locale = locale
        default: break
        }
        
        return dateFormatter.string(from: self)
    }
}

// MARK: - UIView (function)
extension UIView {
    
    /// [設定LayoutConstraint => 不能加frame](https://zonble.gitbooks.io/kkbox-ios-dev/content/autolayout/intrinsic_content_size.html)
    /// - Parameter view: [要設定的View](https://www.appcoda.com.tw/auto-layout-programmatically/)
    func _autolayout(on view: UIView) {

        removeFromSuperview()
        view.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - UIViewController (function)
extension UIViewController {
    
    /// [改變ContainerView](https://disp.cc/b/11-9XMd)
    /// - Parameters:
    ///   - containerView: UIView
    ///   - oldViewController: 舊的ViewController
    ///   - newViewController: 新的ViewController
    func _addChild(on containerView: UIView, from oldViewController: UIViewController? = nil, to newViewController: UIViewController) {
        
        oldViewController?.willMove(toParent: nil)
        oldViewController?.view.removeFromSuperview()
        oldViewController?.removeFromParent()
        
        addChild(newViewController)
        newViewController.view._autolayout(on: containerView)
        newViewController.didMove(toParent: self)
    }
}

