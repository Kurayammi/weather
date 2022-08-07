//
//  WeatherScreenNetworkService.swift
//  weather
//
//  Created by Kito on 7/31/22.
//

import Foundation

struct periodResponseModel: Codable {
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
    let periods: [periodResponseModel]
}

struct GetWeatherResponseModel: Codable {
    let success: Bool
    let response: [WeatherResponseModel]
}

enum Interval {
    case week
    case day
}

final class WeatherScreenNetworkService {
    
    private let networkManager = NetworkManager()
    var didGetWeekResponce: ((_ responce: [periodResponseModel]) -> Void)?
    var didGetHourResponce: ((_ responce: [periodResponseModel]) -> Void)?
    var showError: ((_ title: String, _ message: String) -> Void)?
    
    private func createURLFromParameters(lat: Double,
                                         lon: Double,
                                         from: String? = nil,
                                         _ forInterval: Interval) -> URL {
        
        let coords = "/\(lat),\(lon)"
        var components = URLComponents()
        
        components.scheme = APIDetails.scheme
        components.host   = APIDetails.host
        components.path   = APIDetails.getWeatherDataPath + coords
        components.queryItems = [URLQueryItem]()
        
        ///create parametrs and filters
        let idItem = URLQueryItem(name: "client_id", value: APIDetails.id)
        let secretItem = URLQueryItem(name: "client_secret", value: APIDetails.secret)
        
        switch forInterval {
        case .week: components.queryItems = [idItem, secretItem]
        case .day:
            let fromItem = URLQueryItem(name: "from", value: from)
            let toItem = URLQueryItem(name: "to", value: "+1day")
            let filterItem = URLQueryItem(name: "filter", value: "1hr")
            let limitItem = URLQueryItem(name: "limit", value: "24")
            components.queryItems = [fromItem,
                                     toItem,
                                     filterItem,
                                     limitItem,
                                     idItem,
                                     secretItem]
        }
        
        print(components.url ?? "error")
        return components.url!
    }
    
    func sendDayInfoByHoursRequest(lat: Double,
                                   lon: Double,
                                   from: String? = nil) {
        let url = createURLFromParameters(lat: lat,
                                          lon: lon,
                                          from: from,
                                          .day)
        networkManager.dataRequest(with: url,
                                   objectType: GetWeatherResponseModel.self) { result in
            switch result {
            case.success(let response):
                guard let data = response.response.first?.periods else {
                    self.showError?("Network Error",
                                    "Cant get day info")
                    return
                }
                self.didGetHourResponce?(data)
            case .failure(let error):
                self.showError?("Network Error",
                                "Cant get day info")
                print(error)
            }
        }
    }
    
    func sendWeekInfoRequest(lat: Double, lon: Double) {
        let url = createURLFromParameters(lat: lat,
                                          lon: lon,
                                          .week)
        
        networkManager.dataRequest(with: url, objectType: GetWeatherResponseModel.self) { result in
            switch result {
            case .success(let response):
                guard let data = response.response.first?.periods else {
                    self.showError?("Network Error",
                                    "Cant get day info")
                    return
                }
                self.didGetWeekResponce?(data)
                
            case .failure(let error):
                print(error)
                self.showError?("Network Error",
                                "Cant get week info")
            }
        }
    }
}
