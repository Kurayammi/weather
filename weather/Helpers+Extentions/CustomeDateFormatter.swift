//
//  CustomeDateFormatter.swift
//  weather
//
//  Created by Kito on 8/7/22.
//

import Foundation

final class CustomeDateFormatter {
    func convertDate(time: Int, format: String) -> String {
        let timeInterval = TimeInterval(time)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = format
        
        return dateFormatterGet.string(from: date)
    }
}
