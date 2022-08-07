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
    var didGetResponce: ((_ responce: GetCityResponceModel) -> Void)?
    
    var showError: ((_ title: String, _ message: String) -> Void)?
    
    private func createUrlForCity(cityName: String) -> URL {
        
        var components = URLComponents()
        components.scheme = APIDetails.scheme
        components.host   = APIDetails.host
        components.path   = APIDetails.getCiytDataPath
        
        components.queryItems = [URLQueryItem]()
        
        let idItem = URLQueryItem(name: "client_id", value: APIDetails.id)
        let secretItem = URLQueryItem(name: "client_secret", value: APIDetails.secret)
        
        let nameItem = URLQueryItem(name: "query", value: "name:^\(cityName.lowercased())")
        
        let limitItem = URLQueryItem(name: "limit", value: "20")
        components.queryItems = [nameItem,limitItem, idItem, secretItem]
        
        print(components.url!)
        return components.url!
    }
    
    func sendRequest(cityName: String) {
        let url = createUrlForCity(cityName: cityName)
        
        networkManager.dataRequest(with: url, objectType: GetCityResponceModel.self) { result in
            
            switch result {
            case .success(let response):
                print(response)
                self.didGetResponce?(response)
                
            case .failure(let error):
                self.showError?("Network Error", error.localizedDescription)
            }
        }
    }
}
