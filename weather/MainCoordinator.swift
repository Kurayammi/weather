//
//  MainCoordinator.swift
//  weather
//
//  Created by Kito on 8/2/22.
//

import UIKit
import CoreLocation
final class MainCoordinator {
    private(set) var window: UIWindow
    private var navigationController: UINavigationController?
    
    private let locationManager = LocationManager()
    private var weatherScreenVC: WeatherScreenViewController?
    
    func start() {
        weatherScreenVC = WeatherScreenViewController()
        weatherScreenVC?.start(coordinator: self,
                 currentLocation: nil,
                 currentCityName: nil)
        
        navigationController = UINavigationController(rootViewController: weatherScreenVC ?? UIViewController())
        window.rootViewController = navigationController
        
        window.makeKeyAndVisible()
    }
    
    func pushMapScreen(currentLocation: CLLocationCoordinate2D?,
                       currentCityName: String?) {
        let vc = MapScreenViewController()
        vc.start(coordinator: self,
                 currentLocation: currentLocation,
                 currentCityName: currentCityName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushWeatherScreen(location: CLLocationCoordinate2D?,
                           currentCityName: String?) {
        weatherScreenVC?.start(coordinator: self,
                 currentLocation: location,
                 currentCityName: currentCityName)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func pushCityListScreen(location: CLLocationCoordinate2D?,
                            currentCityName: String?) {
        let vc = CityListScreenViewController()
        vc.start(coordinator: self,
                 currentLocation: location,
                 currentCityName: currentCityName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    init(window: UIWindow) {
        self.window = window
    }
}
