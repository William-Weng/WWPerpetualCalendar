//
//  WWPerpetualCalendar.swift
//  WWPerpetualCalendar
//
//  Created by William.Weng on 2023/1/1.
//

import UIKit
import WWOnBoardingViewController

open class WWPerpetualCalendar: UIViewController {
    
    /// 頁面的滑動方向
    enum PageRotateDirection {
        case none       // 不動
        case left       // 向左
        case right      // 向右
    }
    
    private weak var perpetualCalendarDelegate: WWPerpetualCalendarDelegate?
    
    private static let storyboardName = "Package"
    
    private var baseDate = Date()
    private var currentIndex = 1
    private var currentMonthOffset = 0
    private var firstDayOfMonth: Date?
    private var onBoardingViewController: WWOnBoardingViewController?
    private var pageViewControllerArray: [WWPerpetualCalendarViewController] = []
    private var pageRotateDirection: PageRotateDirection = .none
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        initSetting(for: segue, sender: sender)
    }
}

// MARK: - 公開函式 (public static function)
public extension WWPerpetualCalendar {
    
    /// 建立WWPerpetualCalendar
    /// - Parameters:
    ///   - baseDate: Date
    ///   - perpetualCalendarDelegate: WWPerpetualCalendarDelegate?
    /// - Returns: WWPerpetualCalendar?
    static func build(baseDate: Date = Date(), perpetualCalendarDelegate: WWPerpetualCalendarDelegate? = nil) -> WWPerpetualCalendar? {
        
        let viewController = UIStoryboard._instantiateViewController(name: storyboardName, bundle: .module, identifier: String(describing: WWPerpetualCalendar.self)) as? WWPerpetualCalendar
        viewController?.initSetting(baseDate: baseDate, perpetualCalendarDelegate: perpetualCalendarDelegate)
        
        return viewController
    }
}

// MARK: - 公開函式 (public function)
public extension WWPerpetualCalendar {
    
    /// [手動移到上一個月](https://medium.com/@sharma17krups/onboarding-view-with-swiftui-b26096049be3)
    /// - Parameters:
    ///   - animated: [Bool](https://dev.to/domanovdev/swiftui-onboarding-view-1165)
    ///   - completion: ((Int) -> Void)?
    func previousMonth(animated: Bool = true, completion: ((Int) -> Void)?) {
        onBoardingViewController?.previousPage(animated: animated, completion: completion)
    }
    
    /// [手動移到下一個月](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/scroll-view-決定捲動範圍的-content-layout-guide-6f606740918a)
    /// - Parameters:
    ///   - animated: [Bool](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/在-storyboard-設定-content-size-實現水平捲動的-scroll-view-2710fa247293)
    ///   - completion: ((Int) -> Void)?
    func nextMonth(animated: Bool = true, completion: ((Int) -> Void)?) {
        onBoardingViewController?.nextPage(animated: animated, completion: completion)
    }
    
    /// 指定日期選擇某一個月
    /// - Parameter selectDate: Date?
    /// - Returns: Date?
    func someMonth(selectDate: Date?) {
        
        guard let selectDate = selectDate,
              let currentMonthOffset = monthOffset(from: baseDate, to: selectDate),
              let firstDayOfMonth = reloadPerpetualCalendar(with: currentIndex, monthOffset: currentMonthOffset)
        else {
            return
        }
        
        self.currentMonthOffset = currentMonthOffset
        self.firstDayOfMonth = firstDayOfMonth
        perpetualCalendarDelegate?.didChangeViewController(calendar: self, firstDayOfMonth: firstDayOfMonth, error: nil)
    }
}

// MARK: - PerpetualCalendarDelegate
extension WWPerpetualCalendar: WWPerpetualCalendarViewControllerDelegate {
    
    func perpetualCalendarItem(_ collectionView: UICollectionView, dates: [Date], cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView._reusableCell(at: indexPath) as WWCalendarCollectionViewCell
        cell.configure(with: indexPath)
        
        if let view = perpetualCalendarDelegate?.calendarItemView(collectionView: collectionView, dates: dates, viewForItemAt: indexPath, firstDayOfMonth: firstDayOfMonth) {
            view._autolayout(on: cell)
        }
        
        return cell
    }
    
    func perpetualCalendar(_ collectionView: UICollectionView, dates: [Date], didSelectItemAt indexPath: IndexPath) {
        perpetualCalendarDelegate?.didSelectItem(collectionView: collectionView, dates: dates, at: indexPath)
    }
    
    func perpetualCalendarBaseDate() -> Date {
        return baseDate
    }
}

// MARK: - WWOnBoardingViewControllerDelegate
extension WWPerpetualCalendar: WWOnBoardingViewControllerDelegate {}
public extension WWPerpetualCalendar {
    
    func viewControllers(onBoardingViewController: WWOnBoardingViewController) -> [UIViewController] {
        return pageViewControllerArray
    }
    
    func infinityLoop(onBoardingViewController: WWOnBoardingViewController) -> WWOnBoardingViewController.InfinityLoopInformation {
        let info: WWOnBoardingViewController.InfinityLoopInformation = (hasPrevious: true, hasNext: true)
        return info
    }
    
    func willChangeViewController(_ onBoardingViewController: WWOnBoardingViewController, currentIndex: Int, nextIndex: Int, pageRotateDirection: WWOnBoardingViewController.PageRotateDirection, error: WWOnBoardingViewController.OnBoardingError?) {
        willChangeViewControllerAction(onBoardingViewController: onBoardingViewController, currentIndex: currentIndex, nextIndex: nextIndex, pageRotateDirection: pageRotateDirection, error: error)
    }
    
    func didChangeViewController(_ onBoardingViewController: WWOnBoardingViewController, finishAnimating finished: Bool, transitionCompleted completed: Bool, currentIndex: Int, nextIndex: Int, pageRotateDirection: WWOnBoardingViewController.PageRotateDirection, error: WWOnBoardingViewController.OnBoardingError?) {
        didChangeViewControllerAction(onBoardingViewController: onBoardingViewController, finishAnimating: finished, transitionCompleted: completed, currentIndex: currentIndex, nextIndex: nextIndex, pageRotateDirection: pageRotateDirection, error: error)
    }
}

// MARK: - 小工具
private extension WWPerpetualCalendar {
    
    /// 初始化設定
    /// - Parameters:
    ///   - baseDate: 月曆基準日
    ///   - perpetualCalendarDelegate: WWPerpetualCalendarDelegate?
    func initSetting(baseDate: Date, perpetualCalendarDelegate: WWPerpetualCalendarDelegate?) {
        self.baseDate = baseDate
        self.perpetualCalendarDelegate = perpetualCalendarDelegate
    }
    
    /// 初始化設定
    /// - Parameters:
    ///   - segue: UIStoryboardSegue
    ///   - sender: Any?
    func initSetting(for segue: UIStoryboardSegue, sender: Any?) {
        initPagesSetting()
        initOnBoardingViewControllerSetting(for: segue, sender: sender)
    }
    
    /// 設定UIPageViewController上的ViewControllers
    func initPagesSetting() {
        
        let monthOffsets = [currentMonthOffset - 1, currentMonthOffset, currentMonthOffset + 1]
        
        let array = monthOffsets.compactMap({ monthOffset -> WWPerpetualCalendarViewController? in

            guard let page = UIStoryboard(name: Self.storyboardName, bundle: .module).instantiateViewController(withIdentifier: "PerpetualCalendarViewController") as? WWPerpetualCalendarViewController else { return nil }

            page.loadViewIfNeeded()
            page.calendarDelegate = self
            
            let firstDayOfMonth = page.reloadPerpetualCalendar(monthOffset: monthOffset)
            
            if (monthOffset == currentMonthOffset) {
                self.firstDayOfMonth = firstDayOfMonth
                perpetualCalendarDelegate?.didChangeViewController(calendar: self, firstDayOfMonth: firstDayOfMonth, error: nil)
            }
            
            return page
        })

        pageViewControllerArray = array
    }
    
    /// 找到WWOnBoardingViewController
    /// - Parameters:
    ///   - segue: UIStoryboardSegue
    ///   - sender: Any?
    func initOnBoardingViewControllerSetting(for segue: UIStoryboardSegue, sender: Any?) {
        onBoardingViewController = segue.destination as? WWOnBoardingViewController
        onBoardingViewController?.setting(onBoardingDelegate: self, currentIndex: currentIndex)
    }
    
    /// 處理將要換頁的動作
    /// - Parameters:
    ///   - onBoardingViewController: WWOnBoardingViewController
    ///   - currentIndex: Int
    ///   - nextIndex: Int
    ///   - pageRotateDirection: WWOnBoardingViewController.PageRotateDirection
    ///   - error: WWOnBoardingViewController.OnBoardingError?
    func willChangeViewControllerAction(onBoardingViewController: WWOnBoardingViewController, currentIndex: Int, nextIndex: Int, pageRotateDirection: WWOnBoardingViewController.PageRotateDirection, error: WWOnBoardingViewController.OnBoardingError?) {
        
        if let error = error { perpetualCalendarDelegate?.willChangeViewController(calendar: self, firstDayOfMonth: nil, error: error); return }
        
        switch pageRotateDirection {
        case .right: currentMonthOffset += 1
        case .left: currentMonthOffset -= 1
        case .none: break
        }
        
        let firstDayOfMonth = reloadPerpetualCalendar(with: nextIndex, monthOffset: currentMonthOffset)
        
        self.currentIndex = currentIndex
        self.firstDayOfMonth = firstDayOfMonth
        perpetualCalendarDelegate?.willChangeViewController(calendar: self, firstDayOfMonth: firstDayOfMonth, error: nil)
    }
    
    /// 處理換頁完成的動作
    /// - Parameters:
    ///   - onBoardingViewController: WWOnBoardingViewController
    ///   - finished: Bool
    ///   - completed: Bool
    ///   - currentIndex: Int
    ///   - nextIndex: Int
    ///   - pageRotateDirection: WWOnBoardingViewController.PageRotateDirection
    ///   - error: WWOnBoardingViewController.OnBoardingError?
    func didChangeViewControllerAction(onBoardingViewController: WWOnBoardingViewController, finishAnimating finished: Bool, transitionCompleted completed: Bool, currentIndex: Int, nextIndex: Int, pageRotateDirection: WWOnBoardingViewController.PageRotateDirection, error: WWOnBoardingViewController.OnBoardingError?) {
        
        if let error = error { perpetualCalendarDelegate?.didChangeViewController(calendar: self, firstDayOfMonth: nil, error: error); return }

        let firstDayOfMonth = pageViewControllerArray[safe: currentIndex]?.firstDayOfMonth()
        
        self.currentIndex = currentIndex
        self.firstDayOfMonth = firstDayOfMonth
        perpetualCalendarDelegate?.didChangeViewController(calendar: self, firstDayOfMonth: firstDayOfMonth, error: nil)
    }
    
    /// 重新設定該Index頁面的資訊
    /// - Parameters:
    ///   - index: Int
    ///   - monthOffset: 移動了幾個月
    /// - Returns: 該月的第一天日期
    func reloadPerpetualCalendar(with index: Int, monthOffset: Int) -> Date? {
        
        guard let pageViewController = pageViewControllerArray[safe: index],
              let reloadDate = pageViewController.reloadPerpetualCalendar(monthOffset: monthOffset)
        else {
            return nil
        }
        
        return reloadDate
    }
    
    /// 計算兩日期間的月份差異值
    /// - Parameters:
    ///   - startDate: Date?
    ///   - endDate: Date?
    ///   - calendar: Calendar
    /// - Returns: Int?
    func monthOffset(from startDate: Date?, to endDate: Date?, calendar: Calendar = .current) -> Int? {
        
        guard let fromDate = startDate?._firstDayOfMonth(),
              let toDate = endDate?._firstDayOfMonth(),
              let monthOffset = calendar.dateComponents([.month], from: fromDate, to: toDate).month
        else {
            return nil
        }
        
        return monthOffset
    }
}
