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
    
    func pushWeatherScreen(coords: CLLocationCoordinate2D) {
        let vc = WeatherScreenViewController()
        
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
