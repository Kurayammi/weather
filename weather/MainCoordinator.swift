//
//  MainCoordinator.swift
//  weather
//
//  Created by Kito on 8/2/22.
//

import UIKit
import CoreLocation
final class MainCoordinator {
    var navigationController: UINavigationController?
    
    private let locationManager = LocationManager()
    
    func start() {
        let vc = WeatherScreenViewController()
        vc.start(coordinator: self,
                 currentLocation: nil,
                 currentCityName: nil)
        
        navigationController = UINavigationController(rootViewController: vc)
    }
    
    func pushMapScreen(currentLocation: CLLocationCoordinate2D?) {
        let model = MapScreenVIewModel(currentLocation: currentLocation)
        let vc = MapScreenViewController()
        vc.start(viewModel: model,coordinator: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushWeatherScreen(location: CLLocationCoordinate2D?,
                           currentCityName: String?) {
        let vc = WeatherScreenViewController()
        vc.start(coordinator: self,
                 currentLocation: location,
                 currentCityName: currentCityName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushCityListScreen(location: CLLocationCoordinate2D?,
                            currentCityName: String?) {
        let vc = CityListScreenViewController()
        vc.start(coordinator: self,
                 currentLocation: location,
                 currentCityName: currentCityName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
