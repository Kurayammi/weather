//
//  CityListTableViewCell.swift
//  weather
//
//  Created by Kito on 8/3/22.
//

import UIKit

class CityListTableViewCell: UITableViewCell {

    @IBOutlet private var titleLable: UILabel!
    
    func setup(cityName: String) {
        titleLable.text = cityName
    }
}
