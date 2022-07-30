//
//  WeatherScreenViewController.swift
//  weather
//
//  Created by Kito on 7/30/22.
//

import UIKit

class WeatherScreenViewController: UIViewController {
    
//MARK: IBOutlet
    @IBOutlet private var navigationView: UIView!
    /// DayInfoView
    @IBOutlet private var dayInfoViewConteiner: UIView!
    @IBOutlet private var dayInfoTitleLabel: UILabel!
    @IBOutlet private var dayInfoImageVIew: UIImageView!
   
    @IBOutlet var weekInfoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        
        navigationView.backgroundColor = UIColor(named: "mainColor")
        dayInfoViewConteiner.backgroundColor = UIColor(named: "mainColor")
        dayInfoTitleLabel.text = "Text 1"
        dayInfoImageVIew.image = UIImage(named: "ic_white_day_bright")
        dayInfoImageVIew.tintColor = .white
        
        weekInfoTableView.delegate = self
        weekInfoTableView.dataSource = self
        weekInfoTableView.register(UINib(nibName: "WeekInfoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "WeekInfoItemTableViewCell")
    }
    
}

extension WeatherScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeekInfoItemTableViewCell") as? WeekInfoItemTableViewCell {
            cell.setup(day: "Mn\(indexPath.row)", temp: "\(indexPath.row)", weatherIconName: "ic_white_day_cloudy")
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
}
