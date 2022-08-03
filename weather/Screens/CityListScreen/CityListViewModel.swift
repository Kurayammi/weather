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
    private var cities: [String] = []
    
    var searchedCities: [String] = []
    var currentLocation: CLLocationCoordinate2D?
    var currentCityName: String?
    
    var reloadTableView: (() -> Void)?
    var goBack: (() -> Void)?
    
    func didLoad() {
        parseCitiesJson()
        setupCallbacks()
    }
    func onCellTap(index: Int) {
        networkService.sendRequest(cityName: searchedCities[index])
    }
    
    func lookup(prefix: String?) {
        currentCityName = prefix
        
        if let prefix = prefix {
            if prefix == "" {
                return
            }
            searchedCities = cities.filter { item in
                return item.lowercased().contains(prefix.lowercased())
            }
            reloadTableView?()
        }
    }
    
    private func setupCallbacks() {
        networkService.didGetResponce = {
            location in
            self.currentLocation = location
            self.goBack?()
        }
    }
    
    private func parseCitiesJson() {
        if let url = Bundle.main.url(forResource: "cities", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(GetAllCitiesResponseModel.self, from: data)
                initCities(data: jsonData.data)
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    private func initCities(data: [GetAllCitiesItemResponseModel]) {
        cities = []
        for country in data {
            if let cities = country.cities {
                self.cities += cities
            }
        }
    }
}
