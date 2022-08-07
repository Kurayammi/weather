//
//  MapScreenViewController.swift
//  weather
//
//  Created by Kito on 8/2/22.
//

import UIKit
import MapKit

class MapScreenViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var textField: UITextField!
    
    //MARK: @IBAction
    @IBAction func backButtonAction(_ sender: Any) {
        coordinator?.pushWeatherScreen(
            location: viewModel?.currentLocation,
            currentCityName: viewModel?.inputText)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        viewModel?.onSearchButtonTapped()
    }
    
    private var viewModel: MapScreenVIewModel?
    private weak var coordinator: MainCoordinator?
   
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCallBacks()
        viewModel?.setupCallBacks()
    }
    
    func start(viewModel: MapScreenVIewModel,
               coordinator: MainCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    private func setupUI() {
        setupMap()
        setupTextField()
    }
    
    private func setupMap() {
        if let location = viewModel?.currentLocation {
            
            let region = MKCoordinateRegion( center: location, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
        }
    }
    
    private func setupTextField() {
        textField.delegate = self
        textField.text = nil
        textField.placeholder = "Enter city"
    }
    
    private func setupCallBacks() {
        viewModel?.updateUI = {
            DispatchQueue.main.async {
                self.setupMap()
            }
        }
        
        viewModel?.showAlert = {title, message in
            DispatchQueue.main.async {
                self.showAlertFor(title: title, message: message)
            }
        }
    }
}
//MARK: TextFieldDelegate Extentions
extension MapScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel?.inputText = textField.text
    }
}
