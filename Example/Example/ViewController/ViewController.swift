//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//

import UIKit
import WWOnBoardingViewController
import WWPerpetualCalendar

final class ViewController: UIViewController {
    
    var perpetualCalendar: WWPerpetualCalendar!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var myLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    @IBAction func previousMonth(_ sender: UIBarButtonItem) {
        perpetualCalendar.previousMonth(completion: nil)
    }
    
    @IBAction func nextMonth(_ sender: UIBarButtonItem) {
        perpetualCalendar.nextMonth(completion: nil)
    }
    
    @IBAction func someMonth(_ sender: UIButton) {
        guard let date = Date()._adding(component: .month, value: Int.random(in: 5...10)) else { return }
        self.perpetualCalendar.someMonth(selectDate: date)
    }
}

// MARK: - WWPerpetualCalendarDelegate
extension ViewController: WWPerpetualCalendarDelegate {
    
    func calendarItemView(collectionView: UICollectionView, dates: [Date], viewForItemAt indexPath: IndexPath, firstDayOfMonth: Date?) -> UIView {
        return cellViewMaker(collectionView: collectionView, dates: dates, viewForItemAt: indexPath, firstDayOfMonth: firstDayOfMonth)
    }
    
    func didSelectItem(collectionView: UICollectionView, dates: [Date], at indexPath: IndexPath) {
        didSelectItemAction(collectionView: collectionView, dates: dates, at: indexPath)
    }
    
    func willChangeViewController(calendar: WWPerpetualCalendar, firstDayOfMonth: Date?, error: WWOnBoardingViewController.OnBoardingError?) {
        willChangeViewControllerAction(calendar: calendar, firstDayOfMonth: firstDayOfMonth, error: error)
    }
    
    func didChangeViewController(calendar: WWPerpetualCalendar, firstDayOfMonth: Date?, error: WWOnBoardingViewController.OnBoardingError?) {
        didChangeViewControllerAction(calendar: calendar, firstDayOfMonth: firstDayOfMonth, error: error)
    }
}

// MARK: - 小工具
private extension ViewController {
    
    /// 初始化設定
    func initSetting() {
        let perpetualCalendar = WWPerpetualCalendar.build(perpetualCalendarDelegate: self)!
        self.perpetualCalendar = perpetualCalendar
        self._addChild(on: containerView, to: perpetualCalendar)
    }
    
    /// 產生自定義的CellView
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - dates: [Date]
    ///   - indexPath: IndexPath
    ///   - firstDayOfMonth: Date?
    /// - Returns: UIView
    func cellViewMaker(collectionView: UICollectionView, dates: [Date], viewForItemAt indexPath: IndexPath, firstDayOfMonth: Date?) -> UIView {
        
        guard let date = dates[safe: indexPath.row],
              let firstDayOfMonth = firstDayOfMonth
        else {
            fatalError()
        }
        
        let cellView = CellView()
        cellView.configure(date: date, firstDayOfMonth: firstDayOfMonth)
        
        return cellView
    }
    
    /// 點到該日期的反應
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - dates: [Date]
    ///   - indexPath: IndexPath
    func didSelectItemAction(collectionView: UICollectionView, dates: [Date], at indexPath: IndexPath) {
        
        guard let selectedDate = dates[safe: indexPath.row] else { return }
                
        collectionView.visibleCells.forEach { cell in
            
            guard let cell = cell as? WWCalendarCollectionViewCell,
                  let cellView = cell.subviews.last as? CellView
            else {
                return
            }
            
            cellView.selectedView.isHidden = (cell.indexPath != indexPath) ? true : false
        }
        
        myLabel.text = selectedDate._localTime(with: .short)
    }
    
    /// 將要換頁的反應
    /// - Parameters:
    ///   - calendar: WWPerpetualCalendar
    ///   - firstDayOfMonth: Date?
    ///   - error: WWOnBoardingViewController.OnBoardingError?
    func willChangeViewControllerAction(calendar: WWPerpetualCalendar, firstDayOfMonth: Date?, error: WWOnBoardingViewController.OnBoardingError?) {
        
        if let error = error { myLabel.text = "\(error)"; return }
        myLabel.text = title
    }
    
    /// 換頁完成的反應
    /// - Parameters:
    ///   - calendar: WWPerpetualCalendar
    ///   - firstDayOfMonth: Date?
    ///   - error: WWOnBoardingViewController.OnBoardingError?
    func didChangeViewControllerAction(calendar: WWPerpetualCalendar, firstDayOfMonth: Date?, error: WWOnBoardingViewController.OnBoardingError?) {
        
        if let error = error { myLabel.text = "\(error)"; return }
        
        title = firstDayOfMonth?._localTime(with: .yearMonth)
        myLabel._fadeEffect(0.5)
        myLabel.text = title
    }
}
