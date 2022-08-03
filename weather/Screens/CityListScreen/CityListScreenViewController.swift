//
//  CityListScreenViewController.swift
//  weather
//
//  Created by Kito on 8/3/22.
//

import UIKit
import CoreLocation

final class CityListScreenViewController: UIViewController {
    
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var cityListTableView: UITableView!
    
    @IBAction private func navigationBackButtonAction(_ sender: Any) {
        goBack()
    }
    
    @IBAction private func navigationSearchButtonAction(_ sender: Any) {
        viewModel.lookup(prefix: textField.text)
    }
    
    private let viewModel = CityListViewModel()
    private var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCallBacks()
        viewModel.didLoad()
    }
    
    func start(coordinator: MainCoordinator,
               currentLocation: CLLocationCoordinate2D?,
               currentCityName: String?) {
        self.coordinator = coordinator
        self.viewModel.currentLocation = currentLocation
        self.viewModel.currentCityName = currentCityName
    }
    
    private func setupUI() {
        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        cityListTableView.register(UINib(nibName: "CityListTableViewCell", bundle: nil), forCellReuseIdentifier: "CityListTableViewCell")
        cityListTableView.reloadData()
        
        textField.delegate = self
    }
    
    private func goBack() {
        coordinator?.pushWeatherScreen(
            coords: viewModel.currentLocation,
            currentCiytName: viewModel.currentCityName)
    }
    
    private func setupCallBacks() {
        viewModel.reloadTableView = {
            DispatchQueue.main.async {
                self.cityListTableView.reloadData()
            }
        }
        
        viewModel.goBack = {
            DispatchQueue.main.async {
                self.goBack()
            }
        }
    }
}

extension CityListScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CityListTableViewCell") as? CityListTableViewCell {
            cell.setup(cityName: viewModel.searchedCities[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onCellTap(index: indexPath.row)
    }
    
}

extension CityListScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
