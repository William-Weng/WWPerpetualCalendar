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
    
    func willChangeViewController(firstDayOfMonth: Date?)
    func didChangeViewController(firstDayOfMonth: Date?)
    func didSelectItem(dates: [Date], at indexPath: IndexPath)
    func changeViewController(error: WWOnBoardingViewController.OnBoardingError)
}

// MARK: - 可重複使用的Cell (UITableViewCell / UICollectionViewCell)
protocol CellReusable: AnyObject {
    
    static var identifier: String { get }           /// Cell的Identifier
    var indexPath: IndexPath { get }                /// Cell的IndexPath
    
    /// Cell的相關設定
    /// - Parameter indexPath: IndexPath
    func configure(with indexPath: IndexPath, dates: [Date], firstDay: Date?)
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
    ///   - indexPath: IndexPath
    ///   - dates: 該月份的完整42天的日期
    ///   - firstDay: 該月份的第一天
    /// - Returns: UICollectionViewCell
    func perpetualCalendarItem(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, dates: [Date], firstDay: Date?) -> UICollectionViewCell
    
    /// 萬年曆的Cell點下的動作
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - indexPath: IndexPath
    func perpetualCalendar(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}
