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
    
    static func setupNameForWindImage(windDeg: Double) -> String {
            if windDeg >= 0 && windDeg <= 45{
                return "icon_wind_w"
            } else if windDeg >= 45 && windDeg <= 90 {
                return "icon_wind_wn"
            } else if windDeg >= 90 && windDeg <= 135 {
                return "icon_wind_n"
            } else if windDeg >= 135 && windDeg <= 180 {
                return "icon_wind_ne"
            } else if windDeg >= 180 && windDeg <= 225 {
                return "icon_wind_e"
            } else if windDeg >= 225 && windDeg <= 270 {
                return "icon_wind_se"
            } else if windDeg >= 270 && windDeg <= 315 {
                return "icon_wind_s"
            } else if windDeg >= 315 && windDeg <= 360 {
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
