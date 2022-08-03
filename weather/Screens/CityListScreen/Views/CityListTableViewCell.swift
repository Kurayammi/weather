//
//  CityListTableViewCell.swift
//  weather
//
//  Created by Kito on 8/3/22.
//

import UIKit

class CityListTableViewCell: UITableViewCell {

    @IBOutlet private var titleLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(cityName: String) {
        titleLable.text = cityName
    }
}
