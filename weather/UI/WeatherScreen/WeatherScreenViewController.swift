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
    
    private func setupUI() {
        
        dayInfoImageVIew.image = UIImage(named: "ic_white_day_bright")
        dayInfoImageVIew.tintColor = .white
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
        
    }
    
    private func setupWeekInfoTableView() {
        weekInfoTableView.delegate = self
        weekInfoTableView.dataSource = self
        weekInfoTableView.register(UINib(nibName: "WeekInfoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "WeekInfoItemTableViewCell")
        weekInfoTableView.reloadData()
    }
    
    private func setupCallBacks() {
        viewModel.updateUI = {
            DispatchQueue.main.async {
                self.setupUI()
            }
        }
    }
}

//MARK: TableView Extentions
extension WeatherScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeekInfoItemTableViewCell") as? WeekInfoItemTableViewCell {
            
            cell.setup(day: "Mn\(indexPath.row)",
                       temp: "\(viewModel.weekModel[indexPath.row].maxTempC)",
                       weatherIconName: "ic_white_day_cloudy")
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.weekModel.count
    }
    
}
