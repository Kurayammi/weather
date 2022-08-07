//
//  HourItemCollectionViewCell.swift
//  weather
//
//  Created by Kito on 8/1/22.
//

import UIKit

final class HourItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var tempLabel: UILabel!
    
    func setup(time: Int, imageName: String, temp: String) {
        timeLabel.text = CustomeDateFormatter().convertDate(time: time, format: "HH") + "oo"
        imageView.image = UIImage(named: imageName)
        tempLabel.text = temp + "°"
    }
}
