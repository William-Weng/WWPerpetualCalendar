//
//  CellView.swift
//  Example
//
//  Created by William.Weng on 2024/7/3.
//

import UIKit

// MARK: - 自定義的CellView
final class CellView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var myLabel: UILabel!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromXib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromXib()
    }
    
    func configure(date: Date, firstDayOfMonth: Date) {
        
        myLabel.text = "\(date._component())"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.selectedView.layer.cornerRadius = self.selectedView.frame.width * 0.5
        }
                
        if (date._firstDayOfMonth() != firstDayOfMonth) {
            myLabel.textColor = .lightGray
            underLineView.backgroundColor = .lightGray
            return
        }
        
        if (date._weekday() == 1) {
            myLabel.textColor = .systemRed
            underLineView.backgroundColor = .systemRed
            return
        }
        
        if (date._weekday() == 7) {
            myLabel.textColor = .systemGreen
            underLineView.backgroundColor = .systemGreen
            return
        }
        
        myLabel.textColor = .black
        underLineView.backgroundColor = .black
    }
}

// MARK: - 小工具
private extension CellView {
    
    /// 讀取Nib畫面 => 加到View上面
    func initViewFromXib() {
        
        let bundle = Bundle.main
        let name = String(describing: CellView.self)
        
        bundle.loadNibNamed(name, owner: self, options: nil)
        contentView.frame = bounds
        
        addSubview(contentView)
    }
}
