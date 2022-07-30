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
    /// StackViews
    @IBOutlet private var hoursInfoStackView: UIStackView!
    @IBOutlet private var weekInfoStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        
        navigationView.backgroundColor = UIColor(named: "mainColor")
        dayInfoViewConteiner.backgroundColor = UIColor(named: "mainColor")
        dayInfoTitleLabel.text = "Text 1"
        dayInfoImageVIew.image = UIImage(named: "ic_white_day_bright")
        dayInfoImageVIew.tintColor = .white
        
    }
}
