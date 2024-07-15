//
//  Protocol+.swift
//  WWPerpetualCalendar
//
//  Created by William.Weng on 2023/1/1.
//

import UIKit
import WWOnBoardingViewController

// MARK: - WWPerpetualCalendarDelegate
public protocol WWPerpetualCalendarDelegate: AnyObject {
    
    /// 將要換到下一個月
    /// - Parameters:
    ///   - calendar: WWPerpetualCalendar
    ///   - firstDayOfMonth: 當月的第一天
    ///   - error: WWOnBoardingViewController.OnBoardingError?
    func willChangeViewController(calendar: WWPerpetualCalendar, firstDayOfMonth: Date?, error: WWOnBoardingViewController.OnBoardingError?)
    
    /// 已經換到下一個月
    /// - Parameters:
    ///   - calendar: WWPerpetualCalendar
    ///   - firstDayOfMonth: 當月的第一天
    ///   - error: WWOnBoardingViewController.OnBoardingError?
    func didChangeViewController(calendar: WWPerpetualCalendar, firstDayOfMonth: Date?, error: WWOnBoardingViewController.OnBoardingError?)
    
    /// 點選到該月的某一天
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - dates: 當頁面的所有日期
    ///   - indexPath: IndexPath
    func didSelectItem(collectionView: UICollectionView, dates: [Date], at indexPath: IndexPath)
    
    /// 取得要顯示在Calendar上的ItemView
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - dates: [Date]
    ///   - indexPath: IndexPath
    ///   - firstDayOfMonth: Date?
    /// - Returns: UIView
    func calendarItemView(collectionView: UICollectionView, dates: [Date], viewForItemAt indexPath: IndexPath, firstDayOfMonth: Date?) -> UIView
}

// MARK: - 可重複使用的Cell (UITableViewCell / UICollectionViewCell)
protocol CellReusable: AnyObject {
    
    static var identifier: String { get }           /// Cell的Identifier
    var indexPath: IndexPath { get }                /// Cell的IndexPath
    
    /// Cell的相關設定
    /// - Parameter indexPath: IndexPath
    func configure(with indexPath: IndexPath)
}

// MARK: - 預設 identifier = class name (初值)
extension CellReusable {
    static var identifier: String { return String(describing: Self.self) }
    var indexPath: IndexPath { return [] }
}

// MARK: - 萬年曆Delegate
protocol WWPerpetualCalendarViewControllerDelegate: AnyObject {
    
    /// 萬年曆的基準日
    /// - Returns: Date
    func perpetualCalendarBaseDate() -> Date
    
    /// 萬年曆的Cell長相
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - dates: 該月份的完整42天的日期
    ///   - indexPath: IndexPath
    /// - Returns: UICollectionViewCell
    func perpetualCalendarItem(_ collectionView: UICollectionView, dates: [Date], cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    /// 萬年曆的Cell點下的動作
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - dates: 該月份的完整42天的日期
    ///   - indexPath: IndexPath
    func perpetualCalendar(_ collectionView: UICollectionView, dates: [Date], didSelectItemAt indexPath: IndexPath)
}
