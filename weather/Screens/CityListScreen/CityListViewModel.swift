//
//  CityListViewModel.swift
//  weather
//
//  Created by Kito on 8/3/22.
//

import Foundation
import CoreLocation

struct GetAllCitiesItemResponseModel: Codable {
    let country: String?
    let cities: [String]?
}
struct GetAllCitiesResponseModel: Codable {
    let data: [GetAllCitiesItemResponseModel]
}

final class CityListViewModel {
    private let networkService = CityListNetworkService()
    
    var searchedCities: GetCityResponceModel?
    var currentLocation: CLLocationCoordinate2D?
    var currentCityName: String?
    
    var reloadTableView: (() -> Void)?
    var goBack: (() -> Void)?
    
    func didLoad() {
        setupCallbacks()
    }
    
    func onCellTap(index: Int) {
        guard let lat = searchedCities?.response[index].loc.lat else { return }
        guard let lon = searchedCities?.response[index].loc.long else { return }
        
        currentLocation = CLLocationCoordinate2D(
            latitude: lat,
            longitude: lon)
        
        currentCityName = searchedCities?.response[index].place.name
        goBack?()
    }
    
    func onTextChange(text: String) {
        networkService.sendRequest(cityName: text)
    }
    
    private func setupCallbacks() {
        networkService.didGetResponce = {
            responce in
            print(responce)
            self.searchedCities = responce
            self.reloadTableView?()
        }
    }
}
