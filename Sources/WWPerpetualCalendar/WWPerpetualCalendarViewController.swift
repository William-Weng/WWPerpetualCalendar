//
//  Extension+.swift
//  WWPerpetualCalendar
//
//  Created by William.Weng on 2023/1/1.
//

import UIKit

final class WWPerpetualCalendarViewController: UIViewController {

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    weak var calendarDelegate: WWPerpetualCalendarViewControllerDelegate?
    
    private let calendarCount: (days: Int, weeks: Int) = (7, 6)
    
    private var dates: [Date] = []
    private var monthOffset = 0 {
        didSet { dates = Calendar.current._datesMaker(someday: calendarDelegate?.perpetualCalendarBaseDate(), monthOffset: monthOffset) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView._delegateAndDataSource(with: self)
    }
}

// MARK: - 公開工具
extension WWPerpetualCalendarViewController {
    
    /// 重新讀取月曆資訊
    /// - Parameters:
    ///   - calendar: Calendar
    ///   - monthOffset: Int
    /// - Returns: Date?
    func reloadPerpetualCalendar(_ calendar: Calendar = .current, monthOffset: Int) -> Date? {
        
        self.monthOffset = monthOffset
        self.myCollectionView.reloadData()
        
        return firstDayOfMonth()
    }
    
    /// 取得移動了幾個月
    /// - Returns: Int
    func currentMonthOffset() -> Int {
        return monthOffset
    }
    
    /// 取得該月的第一天
    /// - Returns: Date?
    func firstDayOfMonth() -> Date? {
        return calendarDelegate?.perpetualCalendarBaseDate()._adding(component: .month, value: monthOffset)?._firstDayOfMonth()
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension WWPerpetualCalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return dates.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = calendarDelegate?.perpetualCalendarItem(collectionView, dates: dates, cellForItemAt: indexPath) else { fatalError() }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { calendarDelegate?.perpetualCalendar(collectionView, dates: dates, didSelectItemAt: indexPath) }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WWPerpetualCalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return self.calendarItemSize(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { return .zero }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 1 }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { return 0.5 }
}

// MARK: - 小工具
private extension WWPerpetualCalendarViewController {
    
    /// 計算Item的平均大小
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - collectionViewLayout: UICollectionViewLayout
    ///   - indexPath: IndexPath
    /// - Returns: CGSize
    func calendarItemSize(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / calendarCount.days._CGFloat()
        let height = collectionView.frame.height / calendarCount.weeks._CGFloat()
                
        return CGSize(width: floor(width) - 1, height: floor(height) - 1)
    }
}
