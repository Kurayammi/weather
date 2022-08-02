//
//  WeatherScreenViewController.swift
//  weather
//
//  Created by Kito on 7/30/22.
//

import UIKit

class WeatherScreenViewController: UIViewController {
    
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
    
    private let viewModel = WeatherScreenViewModel()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCallBacks()
        viewModel.didLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: Setup UI
    private func setupUI() {
        
        navigationTitleView.text = viewModel.currentCity
        dayInfoImageVIew.image = UIImage(named: "ic_white_day_bright")
        dayInfoImageVIew.tintColor = .white
        setupHourInfoView()
        setupDayInfoView()
        setupWeekInfoTableView()
    }
    
    private func setupDayInfoView() {
        guard let dayInfo = viewModel.dayModel else { return }
        
        dayInfoTitleLabel.text = Helpers.dateFormatter(time: dayInfo.timestamp, format: "E, d MMM")
        dayInfoTempTitleLabel.text = dayInfo.maxTempC.toString() + "/" + dayInfo.minTempC.toString()
        dayInfoHumidityTitleLabel.text = dayInfo.humidity.toString()
        dayInfoWindTitleLabel.text = dayInfo.windSpeedKPH.toString()
        dayInfoWindOrientationImage.image = UIImage(named: Helpers.setupNameForWindImage(wind_deg: dayInfo.windDirMaxDEG))
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
            }
        }
        
        viewModel.updateUIAfterSelectDay = {
            DispatchQueue.main.async {
                self.setupDayInfoView()
                self.setupHourInfoView()
            }
        }
    }
}

//MARK: TableView Extentions
extension WeatherScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeekInfoItemTableViewCell") as? WeekInfoItemTableViewCell {
            
            cell.setup(
                day: viewModel.weekModel[indexPath.row].timestamp,
                temp: "\(viewModel.weekModel[indexPath.row].maxTempC)",
                       weatherIconName: "ic_white_day_cloudy")
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
            cell.setup(time: viewModel.hoursModel[indexPath.row].timestamp,
                       imageName: "ic_white_day_cloudy",
                       temp: viewModel.hoursModel[indexPath.row].maxTempC.toString())
            
            return cell
        }
        return UICollectionViewCell()
    }
}
