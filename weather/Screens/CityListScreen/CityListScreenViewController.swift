//
//  CityListScreenViewController.swift
//  weather
//
//  Created by Kito on 8/3/22.
//

import UIKit
import CoreLocation

final class CityListScreenViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var cityListTableView: UITableView!
    //MARK: @IBAction
    @IBAction private func navigationBackButtonAction(_ sender: Any) {
        goBack()
    }
    
    @IBAction private func navigationSearchButtonAction(_ sender: Any) {
        guard let text = textField.text else { return }
        viewModel.onTextChange(text: text)
    }
    
    private let viewModel = CityListViewModel()
    private weak var coordinator: MainCoordinator?
    //MARK: Lifecycle
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
        textField.text = nil
        textField.placeholder = "Enter city"
    }
    
    private func goBack() {
        coordinator?.pushWeatherScreen(
            location: viewModel.currentLocation,
            currentCityName: viewModel.currentCityName)
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
//MARK: TableView Extentions
extension CityListScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchedCities?.response.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CityListTableViewCell") as? CityListTableViewCell {
            guard let name = viewModel.searchedCities?.response[indexPath.row].place.name else { return UITableViewCell() }
            
            cell.setup(cityName: name)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onCellTap(index: indexPath.row)
    }
}
//MARK: TextFieldDelegate Extentions
extension CityListScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if textField.text != "" {
            let name = text + string
            viewModel.onTextChange(text: name)
        } else {
            viewModel.onTextChange(text: string)
        }
        
        return true
    }
}
