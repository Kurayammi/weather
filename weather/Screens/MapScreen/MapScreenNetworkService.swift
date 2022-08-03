//
//  MapScreenNetworkService.swift
//  weather
//
//  Created by Kito on 8/2/22.
//

import Foundation
import CoreLocation

struct GetLocation: Codable {
    let lat: Double
    let long: Double
}
struct GetCity: Codable {
    let loc: GetLocation
}

struct GetCityResponceModel: Codable {
    let response: [GetCity]
}

final class MapScreenNetworkService {
    
    private let networkManager = NetworkManager()
    var didGetResponce: ((_ location: CLLocationCoordinate2D) -> Void)?
    private func createUrlForCity(cityName: String) -> URL {
        
        var components = URLComponents()
        components.scheme = APIDetails.Scheme
        components.host   = APIDetails.Host
        components.path   = APIDetails.GetCiytDataPath
        
        components.queryItems = [URLQueryItem]()
        
        let idItem = URLQueryItem(name: "client_id", value: APIDetails.Id)
        let secretItem = URLQueryItem(name: "client_secret", value: APIDetails.Secret)
        
        let nameItem = URLQueryItem(name: "query", value: "name:\(cityName.lowercased())")
        
        components.queryItems = [nameItem, idItem, secretItem]
        
        return components.url!
    }
    
    func sendRequest(cityName: String) {
        let url = createUrlForCity(cityName: cityName)
        
        networkManager.dataRequest(with: url, objectType: GetCityResponceModel.self) { result in
            
            switch result {
            case .success(let response):
                print(response)
                //let data = response.response[0].periods
                //self.didGetWeekResponce?(data)
                guard let lat = response.response.first?.loc.lat else {return}
                guard let lon = response.response.first?.loc.long else { return }
                
                let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                self.didGetResponce?(location)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
