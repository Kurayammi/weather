//
//  WeekInfoItemTableViewCell.swift
//  weather
//
//  Created by Kito on 7/30/22.
//

import UIKit

class WeekInfoItemTableViewCell: UITableViewCell {

    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(day: Int,
               maxTemp: Int,
               minTemp: Int,
               weatherIconName: String) {
        dayLabel.text = Helpers.dateFormatter(time: day, format: "E")
        tempLabel.text = maxTemp.toString() + "°/ " + minTemp.toString() + "°"
        weatherIcon.image = UIImage(named: weatherIconName)
    }
}
