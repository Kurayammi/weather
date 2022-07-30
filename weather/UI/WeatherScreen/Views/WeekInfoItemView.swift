//
//  WeekInfoItemView.swift
//  weather
//
//  Created by Kito on 7/30/22.
//

import UIKit

class WeekInfoItemView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setupInfo(day: String, temp: String, imageName: String) {
        dayLabel.text = day
        tempLabel.text = temp
        imageView.image = UIImage(named: imageName)
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("WeekInfoItemView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
