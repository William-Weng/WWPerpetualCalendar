//
//  WWCalendarCollectionViewCell.swift
//  WWPerpetualCalendar
//
//  Created by William.Weng on 2023/1/1.
//

import UIKit

// MARK: - 該月當日的CELL
open class WWCalendarCollectionViewCell: UICollectionViewCell, CellReusable {
    
    public var indexPath: IndexPath = []
    
    public override func prepareForReuse() { self.subviews._removeFromSuperview() }
    
    func configure(with indexPath: IndexPath) {
        self.indexPath = indexPath
    }
}
