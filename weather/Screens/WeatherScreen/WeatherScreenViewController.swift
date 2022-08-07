//
//  WeatherScreenViewController.swift
//  weather
//
//  Created by Kito on 7/30/22.
//

import UIKit
import CoreLocation
final class WeatherScreenViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet private var navigationTitleView: UILabel!
    /// DayInfoView
    @IBOutlet private var dayInfoTitleLabel: UILabel!
    @IBOutlet private var dayInfoImageVIew: UIImageView!
    @IBOutlet private var dayInfoTempTitleLabel: UILabel!
    @IBOutlet private var dayInfoHumidityTitleLabel: UILabel!
    @IBOutlet private var dayInfoWindTitleLabel: UILabel!
    @IBOutlet private var dayInfoWindOrientationImage: UIImageView!
    /// HourInfoView
    @IBOutlet private var hourInfoCollectionView: UICollectionView!
    /// WeekInfoView
    @IBOutlet var weekInfoTableView: UITableView!
    
    //MARK: @IBAction
    @IBAction func mapButtonAction(_ sender: Any) {
        coordinator?.pushMapScreen(currentLocation: viewModel.didEnd())
    }
    @IBAction func cityListButtonAction(_ sender: Any) {
        coordinator?.pushCityListScreen(location: viewModel.didEnd(),
                                        currentCityName: viewModel.currentCityName)
    }
    
    private let viewModel = WeatherScreenViewModel()
    private weak var coordinator: MainCoordinator?
    private var loaderView = LoaderView()
    
    func start(coordinator: MainCoordinator,
               currentLocation: CLLocationCoordinate2D?,
               currentCityName: String?) {
        self.coordinator = coordinator
        viewModel.currentLocation = currentLocation
        viewModel.currentCityName = currentCityName
        viewModel.sendRequests()
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCallBacks()
        viewModel.didLoad()
        setupUI()
        setupLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: Setup UI
    private func setupUI() {
        
        navigationTitleView.text = viewModel.currentCityName
        dayInfoImageVIew.tintColor = .white
        setupHourInfoView()
        setupDayInfoView()
        setupWeekInfoTableView()
    }
    
    private func setupLoader() {
        loaderView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.view.frame.width,
                                  height: self.view.frame.height)
        
        self.view.addSubview(loaderView)
    }
    
    private func setupDayInfoView() {
        guard let dayInfo = viewModel.dayModel else { return }
        let imageName = Helpers.getImageNameFromWeatherCode(code: dayInfo.weatherPrimaryCoded, isDay: dayInfo.isDay)
        dayInfoImageVIew.image = UIImage(named: imageName)
        
        dayInfoTitleLabel.text = Helpers.dateFormatter(time: dayInfo.timestamp, format: "E, d MMM")
        dayInfoTempTitleLabel.text = dayInfo.maxTempC.toString() + "°/ " + dayInfo.minTempC.toString() + "°"
        dayInfoHumidityTitleLabel.text = dayInfo.humidity.toString() + "%"
        dayInfoWindTitleLabel.text = dayInfo.windSpeedKPH.toString() + " km/h"
        dayInfoWindOrientationImage.image = UIImage(named: Helpers.setupNameForWindImage(windDeg: dayInfo.windDirMaxDEG))
    }
    
    private func setupHourInfoView() {
        hourInfoCollectionView.delegate = self
        hourInfoCollectionView.dataSource = self
        hourInfoCollectionView.register(UINib(nibName: "HourItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourItemCollectionViewCell")
        hourInfoCollectionView.reloadData()
    }
    
    private func setupWeekInfoTableView() {
        weekInfoTableView.delegate = self
        weekInfoTableView.dataSource = self
        weekInfoTableView.register(UINib(nibName: "WeekInfoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "WeekInfoItemTableViewCell")
        weekInfoTableView.reloadData()
    }
    
    //MARK: Setup Callbacks
    private func setupCallBacks() {
        viewModel.updateUI = {
            DispatchQueue.main.async {
                self.setupUI()
                self.loaderView.isHidden = true
            }
        }
        
        viewModel.updateUIAfterSelectDay = {
            DispatchQueue.main.async {
                self.setupDayInfoView()
                self.setupHourInfoView()
            }
        }
        
        viewModel.showAlert = {title, message in
            DispatchQueue.main.async {
                self.showAlertFor(title: title, message: message)
            }
        }
    }
}
//MARK: TableView Extentions
extension WeatherScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeekInfoItemTableViewCell") as? WeekInfoItemTableViewCell {
            
            let imageName = Helpers.getImageNameFromWeatherCode(
                code: viewModel.weekModel[indexPath.row].weatherPrimaryCoded,
                isDay: viewModel.weekModel[indexPath.row].isDay)
            
            cell.setup(
                day: viewModel.weekModel[indexPath.row].timestamp,
                maxTemp: viewModel.weekModel[indexPath.row].maxTempC,
                minTemp: viewModel.weekModel[indexPath.row].minTempC,
                weatherIconName: imageName)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.weekModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onDayTap(index: indexPath.row)
    }
}

//MARK: CollectionView Extentions
extension WeatherScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.hoursModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourItemCollectionViewCell", for: indexPath) as? HourItemCollectionViewCell {
            
            let imageName = Helpers.getImageNameFromWeatherCode(
                code: viewModel.hoursModel[indexPath.row].weatherPrimaryCoded,
                isDay: viewModel.hoursModel[indexPath.row].isDay)
            
            cell.setup(time: viewModel.hoursModel[indexPath.row].timestamp,
                       imageName: imageName,
                       temp: viewModel.hoursModel[indexPath.row].maxTempC.toString())
            
            return cell
        }
        return UICollectionViewCell()
    }
}
