# WWPerpetualCalendar

[![Swift-5.6](https://img.shields.io/badge/Swift-5.6-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-14.0](https://img.shields.io/badge/iOS-14.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![TAG](https://img.shields.io/github/v/tag/William-Weng/WWPerpetualCalendar) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

## [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- Use the functions of UIPageViewController to make a simple perpetual calendar.
- 利用UIPageViewController的功能，製作一個簡單的萬年月曆。

## [Achievements display - 成果展示](https://www.hkweb.com.hk/blog/ui設計基礎知識：引導頁對ui設計到底有什麼作用/)
![WWPerpetualCalendar](./Example.gif)

## [Installation with Swift Package Manager - 安裝方式](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)

```bash
dependencies: [
    .package(url: "https://github.com/William-Weng/WWPerpetualCalendar.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage - 使用方式
- Add Perpetual Calendar to ContainerView.
- 將WWPerpetualCalendar加入到ContainerView之中

![WWPerpetualCalendar](./Example.png)

## Function - 可用函式

|函式|功能|
|-|-|
|previousMonth(animated:completion:)|回上一個月|
|nextMonth(animated:completion:)|到下一個月|
|someMonth(selectDate:)|到某一個月|

## WWPerpetualCalendarDelegate

|函式|功能|
|-|-|
|willChangeViewController(firstDayOfMonth:)|將要換到下一個月|
|didChangeViewController(firstDayOfMonth:)|已經換到下一個月|
|didSelectItem(dates:at)|點選到該月的某一天|
|changeViewController(error:)|取得錯誤|

## Example - 程式範例
```swift
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
```
