//
//  WeatherScreenNetworkService.swift
//  weather
//
//  Created by Kito on 7/31/22.
//

import Foundation

struct GetCityResponseModel: Codable {
    let name: String
    let lat: Double
    let lon: Double
}

struct periodResponseModel: Codable {
    let timestamp: Int
    let maxTempC: Int
    let minTempC: Int
    let humidity: Int
    let windDirMaxDEG: Double
    let windSpeedKPH: Double
    let weatherPrimaryCoded: String
}

struct GetWeatherResponseModel: Codable {
    let interval: String
    let periods: [periodResponseModel]
}

struct ResponceModel: Codable {
    let success: Bool
    let response: [GetWeatherResponseModel]
}

enum Interval {
    case week
    case day
}

final class WeatherScreenNetworkService {
    
    private let networkManager = NetworkManager()
    var didGetWeekResponce: ((_ responce: [periodResponseModel]) -> Void)?
    var didGetHourResponce: ((_ responce: [periodResponseModel]) -> Void)?
    
    private func createURLFromParameters(lat: Double,
                                         lon: Double,
                                         from: String? = nil,
                                         _ forInterval: Interval) -> URL {
        
        let coords = "/\(lat),\(lon)"
        var components = URLComponents()
        
        components.scheme = APIDetails.Scheme
        components.host   = APIDetails.Host
        components.path   = APIDetails.DataPath + coords
        components.queryItems = [URLQueryItem]()
        
        ///create parametrs and filters
        let idItem = URLQueryItem(name: "client_id", value: APIDetails.Id)
        let secretItem = URLQueryItem(name: "client_secret", value: APIDetails.Secret)
        
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
        
        print(components.url ?? "sss")
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
                                   objectType: ResponceModel.self) { result in
            switch result {
            case.success(let response):
                let data = response.response[0].periods
                self.didGetHourResponce?(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendWeekInfoRequest(lat: Double, lon: Double) {
        let url = createURLFromParameters(lat: lat,
                                          lon: lon,
                                          .week)
        
        networkManager.dataRequest(with: url, objectType: ResponceModel.self) { result in
            switch result {
            case .success(let response):
                print(response.response[0].periods.count)
                let data = response.response[0].periods
                self.didGetWeekResponce?(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
