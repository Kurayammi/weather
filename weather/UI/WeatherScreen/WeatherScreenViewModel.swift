//
//  WeatherScreenViewModel.swift
//  weather
//
//  Created by Kito on 7/31/22.
//

import Foundation

final class WeatherScreenViewModel {
    private let networkService = WeatherScreenNetworkService()
    private let locationManager = LocationManager()
    
    var weekModel: [periodResponseModel] = []
    var dayModel: periodResponseModel?
    var hoursModel: [periodResponseModel] = []
    var updateUI: (() -> Void)?
    
    func didLoad() {
        locationManager.requestLocation()
        locationManager.didGetLocation = networkService.sendRequest
        networkService.didGetResponce = didGetResponce
    }
    
    private func didGetResponce(responce: [periodResponseModel]) {
        self.weekModel = responce
        self.dayModel = responce.first
        updateUI?()
    }
}
