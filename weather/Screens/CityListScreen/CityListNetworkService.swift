//
//  CityListNetworkService.swift
//  weather
//
//  Created by Kito on 8/3/22.
//

import Foundation
import CoreLocation

final class CityListNetworkService {
    
    private let networkManager = NetworkManager()
    var didGetResponce: ((_ location: CLLocationCoordinate2D) -> Void)?
    private func createUrlForCity(cityName: String) -> URL {
        
        var components = URLComponents()
        components.scheme = APIDetails.scheme
        components.host   = APIDetails.host
        components.path   = APIDetails.getCiytDataPath
        
        components.queryItems = [URLQueryItem]()
        
        let idItem = URLQueryItem(name: "client_id", value: APIDetails.id)
        let secretItem = URLQueryItem(name: "client_secret", value: APIDetails.secret)
        
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
