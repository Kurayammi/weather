//
//  WeatherResponceModel.swift
//  weather
//
//  Created by Kito on 8/7/22.
//

import Foundation

struct PeriodResponseModel: Codable {
    let timestamp: Int
    let maxTempC: Int
    let minTempC: Int
    let humidity: Int
    let windDirMaxDEG: Double
    let windSpeedKPH: Double
    let weatherPrimaryCoded: String
    let isDay: Bool
}

struct WeatherResponseModel: Codable {
    let interval: String
    let periods: [PeriodResponseModel]
}

struct GetWeatherResponseModel: Codable {
    let success: Bool
    let response: [WeatherResponseModel]
}
