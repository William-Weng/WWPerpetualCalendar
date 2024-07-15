//
//  Extension+.swift
//  WWPerpetualCalendar
//
//  Created by William.Weng on 2023/1/1.
//

import UIKit

// MARK: - UIStoryboard (static function)
extension UIStoryboard {
    
    /// 由UIStoryboard => ViewController
    /// - Parameters:
    ///   - name: Storyboard的名稱 => Main.storyboard
    ///   - storyboardBundleOrNil: Bundle名稱
    ///   - identifier: ViewController的代號 (記得要寫)
    /// - Returns: T (泛型) => UIViewController
    static func _instantiateViewController<T: UIViewController>(name: String = "Main", bundle storyboardBundleOrNil: Bundle? = nil, identifier: String = String(describing: T.self)) -> T {
        
        let viewController = Self(name: name, bundle: storyboardBundleOrNil).instantiateViewController(identifier: identifier) as T
        return viewController
    }
}

// MARK: - Collection (override class function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}

// MARK: - Collection (function)
extension Collection {
    
    /// 計算Index / Count - 1
    /// - Returns: Int
    func _index() -> Int { return count - 1 }
}

// MARK: - Collection (function)
extension Collection where Self.Element: UIView {
        
    /// 將所有View移除
    func _removeFromSuperview() {
        self.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - Int (class function)
extension Int {
    
    /// 轉成CGFloat
    /// - Returns: CGFloat
    func _CGFloat() -> CGFloat { return CGFloat(self) }
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
    
    /// 取得當月的第一天
    /// - Parameter calendar: 當地的日曆基準
    /// - Returns: Date?
    func _firstDayOfMonth(for calendar: Calendar = .current) -> Date? {
        let dateComponents = calendar.dateComponents([.month, .year], from: self)
        return calendar.date(from: dateComponents)
    }
    
    /// [當天是當週的第幾天？](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/請問-swift-大大-今天星期幾-bf2935e33b6)
    /// - 週日算第1天 / 週六算第7天
    /// - Parameter calendar:C alendar
    /// - Returns: Int
    func _weekday(for calendar: Calendar = .current) -> Int { return self._component(.weekday) }
    
    /// 時間其中一位的數值 => 年？月？日？
    /// - Returns: Int
    /// - Parameters:
    ///   - component: 單位 => .day
    ///   - calendar: 當地的日曆基準
    func _component(_ component: Calendar.Component = .day, for calendar: Calendar = .current) -> Int {
        return calendar.component(component, from: self)
    }
    
    /// 產生當天月份的萬年曆資訊 (6週 / 42天)
    /// - Parameter calendar: Calendar
    /// - Returns: [Date]
    func _perpetualCalendar(for calendar: Calendar = .current) -> [Date] {
        return calendar._datesMaker(someday: self)
    }
    
    /// [比較日期文字是否相等？](https://areckkimo.medium.com/用uipageviewcontroller實作萬年曆-76edaac841e1)
    /// - Parameters:
    ///   - anotherDate: 另一個要比較的日期
    ///   - timeZone: 時區
    ///   - dateFormat: 要比較的日期格式 (不一定要比完整的日期)
    /// - Returns: Bool
    func _compare(equal anotherDate: Date?, with dateFormat: Constant.DateFormat = .full, timeZone: TimeZone = .current) -> Bool {
        
        guard let thisDate = self._localTime(with: dateFormat, timeZone: timeZone),
              let anotherDate = anotherDate?._localTime(with: dateFormat, timeZone: timeZone)
        else {
            return false
        }
        
        return thisDate == anotherDate
    }
}

// MARK: - Calendar (function)
extension Calendar {
    
    /// [萬年曆數值產生器](https://areckkimo.medium.com/用uipageviewcontroller實作萬年曆-76edaac841e1)
    /// - Parameters:
    ///   - someday: 該月的某一天
    ///   - monthOffset: -1 <- 當月 -> +1
    ///   - days: 一週有幾天
    ///   - weeks: 要顯示幾週
    /// - Returns: [Date]?
    func _datesMaker(someday: Date?, monthOffset: Int = 0, days: Int = 7, weeks: Int = 6) -> [Date] {
        
        guard let someday = someday,
              let selectedDayOfMonth = someday._adding(component: .month, value: monthOffset, for: self),
              let firstDayOfMonth = selectedDayOfMonth._firstDayOfMonth(for: self),
              let firstDayWeek = Optional.some(firstDayOfMonth._weekday(for: self))
        else {
            return []
        }
        
        var calendarDates: [Date] = []
        
        for index in 0..<(days * weeks) {
            let offsetDays = index - firstDayWeek + 1
            if let date = firstDayOfMonth._adding(value: offsetDays) { calendarDates.append(date) }
        }
        
        return calendarDates
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

// MARK: - UICollectionView (function)
extension UICollectionView {
    
    /// 初始化Protocal
    /// - Parameter this: UICollectionViewDelegate & UICollectionViewDataSource
    func _delegateAndDataSource(with this: UICollectionViewDelegate & UICollectionViewDataSource) {
        self.delegate = this
        self.dataSource = this
    }
    
    /// 取得UICollectionViewCell
    /// - let cell = collectionView._reusableCell(at: indexPath) as MyCollectionViewCell
    /// - Parameter indexPath: IndexPath
    /// - Returns: 符合CellReusable的Cell
    func _reusableCell<T: CellReusable>(at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else { fatalError("UICollectionViewCell Error") }
        return cell
    }
    
    /// 註冊Cell (使用Class)
    /// - Parameter cellClass: 符合CellReusable的Cell
    func _registerCell<T: CellReusable>(with cellClass: T.Type) { register(cellClass.self, forCellWithReuseIdentifier: cellClass.identifier) }
}

// MARK: - String (function)
extension String {
    
    /// 將"2020-07-08 16:36:31 +0800" => Date()
    /// - Parameters:
    ///   - dateFormat: Constant.DateFormat
    ///   - timeZone: TimeZone
    /// - Returns: Date?
    func _date(dateFormat: Constant.DateFormat = .short, timeZone: TimeZone = .current) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "\(dateFormat)"
        dateFormatter.timeZone = timeZone
        
        switch dateFormat {
        case .meridiem(formatLocale: let locale): dateFormatter.locale = locale
        default: break
        }
        
        return dateFormatter.date(from: self)
    }
}

// MARK: - Date (class function)
extension Date {
    
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
