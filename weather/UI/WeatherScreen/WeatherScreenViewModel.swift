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
    
    var currentCity: String {
        get{
            return locationManager.currentCityName ?? ""
        }
    }
    
    var updateUI: (() -> Void)?
    var updateUIAfterSelectDay: (() -> Void)?
    
    func didLoad() {
        locationManager.requestLocation()
        locationManager.didGetLocation = { lat, lon in
            self.networkService.sendWeekInfoRequest(lat: lat, lon: lon)
            self.networkService.sendDayInfoByHoursRequest(lat: lat, lon: lon)
        }
        
        networkService.didGetWeekResponce = didGetWeekResponce
        networkService.didGetHourResponce = didGetHourResponce
    }
    
    func onDayTap(index: Int) {
        guard let lat = locationManager.location?.latitude else {return}
        guard let lon = locationManager.location?.longitude else {return}
        let from = weekModel[index].timestamp.toString()
        networkService.sendDayInfoByHoursRequest(lat: lat,
                                                 lon: lon,
                                                 from: from)
    }
    
    private func didGetWeekResponce(responce: [periodResponseModel]) {
        self.weekModel = responce
        updateUI?()
    }
    
    private func didGetHourResponce(responce: [periodResponseModel]) {
        self.hoursModel = responce
        self.dayModel = responce.first
        updateUIAfterSelectDay?()
    }
}
