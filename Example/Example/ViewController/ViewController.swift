//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//  ~/Library/Caches/org.swift.swiftpm/

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
    
    @IBAction func somePage(_ sender: UIButton) {
        guard let date = Date()._adding(component: .month, value: Int.random(in: 5...10)) else { return }
        self.perpetualCalendar.someMonth(selectDate: date)
    }
}

// MARK: - WWPerpetualCalendarDelegate
extension ViewController: WWPerpetualCalendarDelegate {
    
    func willChangeViewController(firstDayOfMonth: Date?) {
        title = firstDayOfMonth?._localTime(with: .yearMonth)
        myLabel.text = title
    }
    
    func didChangeViewController(firstDayOfMonth: Date?) {
        title = firstDayOfMonth?._localTime(with: .yearMonth)
        myLabel.text = title
    }
    
    func didSelectItem(dates: [Date], at indexPath: IndexPath) {
        guard let selectedDate = dates[safe: indexPath.row] else { return }
        myLabel.text = selectedDate._localTime(with: .short)
    }
    
    func changeViewController(error: WWOnBoardingViewController.OnBoardingError) {
        myLabel.text = "\(error)"
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
}
