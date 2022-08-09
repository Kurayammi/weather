//
//  MapScreenVIewModel.swift
//  weather
//
//  Created by Kito on 8/2/22.
//

import Foundation
import CoreLocation

final class MapScreenVIewModel {
    private let networkService = MapScreenNetworkService()
    
    var updateUI: (() -> Void)?
    var currentLocation: CLLocationCoordinate2D?
    var currentCityName: String?
    var inputText: String?
    
    var showAlert: ((_ title: String, _ message: String) -> Void)?
    
    func onSearchButtonTapped() {
        if let inputText = inputText {
            networkService.sendRequest(cityName: inputText)
        }
    }
    
    func setupCallBacks() {
        networkService.didGetResponce = { location in
            self.currentLocation = location
            self.currentCityName = self.inputText
            self.updateUI?()
        }
        networkService.showError = showAlert
    }
}
