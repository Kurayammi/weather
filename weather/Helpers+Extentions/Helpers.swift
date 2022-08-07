//
//  Helpers.swift
//  weather
//
//  Created by Kito on 8/1/22.
//

import Foundation

final class Helpers {
    
    static func dateFormatter(time: Int, format: String) -> String {
            let timeInterval = TimeInterval(time)
            let date = Date(timeIntervalSince1970: timeInterval)
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = format
            
            return dateFormatterGet.string(from: date)
        }
    
    static func setupNameForWindImage(wind_deg: Double) -> String {
            if wind_deg >= 0 && wind_deg <= 45{
                return "icon_wind_w"
            } else if wind_deg >= 45 && wind_deg <= 90 {
                return "icon_wind_wn"
            } else if wind_deg >= 90 && wind_deg <= 135 {
                return "icon_wind_n"
            } else if wind_deg >= 135 && wind_deg <= 180 {
                return "icon_wind_ne"
            } else if wind_deg >= 180 && wind_deg <= 225 {
                return "icon_wind_e"
            } else if wind_deg >= 225 && wind_deg <= 270 {
                return "icon_wind_se"
            } else if wind_deg >= 270 && wind_deg <= 315 {
                return "icon_wind_s"
            } else if wind_deg >= 315 && wind_deg <= 360 {
                return "icon_wind_ws"
            }
            return ""
        }
    
    static func getImageNameFromWeatherCode(code: String, isDay: Bool) -> String {
        let splitedCode = code.split(separator: ":")
        let cloudCode = splitedCode.first
        let weatherCode = splitedCode.last
        
        var time = ""
        var coverage = ""
        var weather = ""
        if isDay {
            time = "day"
        } else {
            time = "night"
        }
        
        switch cloudCode {
        case "CL": coverage = "bright"
        default: coverage = "cloudy"
        }
        
        switch weatherCode {
        case "R", "RS": weather = "rain"
        case "RW": weather = "shower"
        case "T": weather = "thunder"
        default: weather = ""
        }
        
        if weather != "" {
            return "ic_white_\(time)_\(weather)"
        } else {
            return "ic_white_\(time)_\(coverage)"
        }
    }
}
