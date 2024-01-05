//
//  WWCalendarCollectionViewCell.swift
//  WWPerpetualCalendar
//
//  Created by William.Weng on 2023/1/1.
//

import UIKit

// MARK: - 該月當日的CELL
final class WWCalendarCollectionViewCell: UICollectionViewCell, CellReusable {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var underLineView: UIView!
    
    static var dates: [Date] = []
    
    var indexPath: IndexPath = []
    
    func configure(with indexPath: IndexPath, dates: [Date], firstDay: Date?) {
        
        guard let date = dates[safe: indexPath.row],
              let isEqual = firstDay?._compare(equal: date, with: .yearMonth)
        else {
            return
        }
        
        var dayType: Constant.CalendarCellDayType = (!isEqual) ? .none : .general
        
        self.indexPath = indexPath
        Self.dates = dates
        
        myLabel.text = date._localTime(with: .day)

        if (isEqual) {
            let weekday = date._weekday()
            if (weekday == 1) { dayType = .sunday }
            if (weekday == 7) { dayType = .saturday }
        }
        
        myLabel.textColor = dayType.color()
        underLineView.backgroundColor = dayType.underLineColor()
    }
}
