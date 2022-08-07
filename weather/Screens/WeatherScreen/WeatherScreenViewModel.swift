//
//  WeatherScreenViewModel.swift
//  weather
//
//  Created by Kito on 7/31/22.
//

import Foundation
import CoreLocation

final class WeatherScreenViewModel {
    private let networkService = WeatherScreenNetworkService()
    private let locationManager = LocationManager()
    
    var weekModel: [periodResponseModel] = []
    var dayModel: periodResponseModel?
    var hoursModel: [periodResponseModel] = []
    
    var currentLocation: CLLocationCoordinate2D?
    var currentCityName: String?
    
    var updateUI: (() -> Void)?
    var updateUIAfterSelectDay: (() -> Void)?
    
    func didLoad() {
        setupCallBacks()
        sendRequests()
    }
    
    func sendRequests() {
        if currentLocation == nil {
            locationManager.requestLocation()
        } else {
            guard let currentLocation = currentLocation else {return}
            networkService.sendWeekInfoRequest(
                lat: currentLocation.latitude,
                lon: currentLocation.longitude)
            
            networkService.sendDayInfoByHoursRequest(
                lat: currentLocation.latitude,
                lon: currentLocation.longitude)
        }
    }
    func didEnd() -> CLLocationCoordinate2D? {
        return locationManager.location
    }
    
    func onDayTap(index: Int) {
        guard let lat = locationManager.location?.latitude else {return}
        guard let lon = locationManager.location?.longitude else {return}
        let from = weekModel[index].timestamp.toString()
        dayModel = weekModel[index]
        
        networkService.sendDayInfoByHoursRequest(lat: lat,
                                                 lon: lon,
                                                 from: from)
    }
    
    private func setupCallBacks() {
        locationManager.didGetLocation = { lat, lon in
            self.networkService.sendWeekInfoRequest(lat: lat, lon: lon)
            self.networkService.sendDayInfoByHoursRequest(lat: lat, lon: lon)
        }
        
        networkService.didGetWeekResponce = didGetWeekResponce
        networkService.didGetHourResponce = didGetHourResponce
    }
    
    private func didGetWeekResponce(responce: [periodResponseModel]) {
        self.weekModel = responce
        if self.currentCityName == nil {
            self.currentCityName = self.locationManager.currentCityName
        }
        self.dayModel = weekModel.first
        updateUI?()
    }
    
    private func didGetHourResponce(responce: [periodResponseModel]) {
        self.hoursModel = responce
        updateUIAfterSelectDay?()
    }
}
