//
//  MainCoordinator.swift
//  weather
//
//  Created by Kito on 8/2/22.
//

import UIKit
import CoreLocation
final class MainCoordinator {
    let navigationController: UINavigationController
    
    private let locationManager = LocationManager()
    
    func pushMapScreen(currentLocation: CLLocationCoordinate2D?) {
        let model = MapScreenVIewModel(currentLocation: currentLocation)
        let vc = MapScreenViewController()
        vc.start(viewModel: model,coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func pushWeatherScreen(coords: CLLocationCoordinate2D?,
                           currentCiytName: String?) {
        let model = WeatherScreenViewModel()
        model.currentLocation = coords
        model.currentCity = currentCiytName
        let vc = WeatherScreenViewController()
        vc.start(coordinator: self,
                 viewModel: model)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func pushCityListScreen(location: CLLocationCoordinate2D?,
                            currentCityName: String?) {
        let vc = CityListScreenViewController()
        vc.start(coordinator: self,
                 currentLocation: location,
                 currentCityName: currentCityName)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
