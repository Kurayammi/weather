//
//  WeekInfoItemTableViewCell.swift
//  weather
//
//  Created by Kito on 7/30/22.
//

import UIKit

final class WeekInfoItemTableViewCell: UITableViewCell {
    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var weatherIcon: UIImageView!

    func setup(day: Int,
               maxTemp: Int,
               minTemp: Int,
               weatherIconName: String) {
        dayLabel.text = Helpers.dateFormatter(time: day, format: "E")
        tempLabel.text = maxTemp.toString() + "°/ " + minTemp.toString() + "°"
        weatherIcon.image = UIImage(named: weatherIconName)
    }
}
