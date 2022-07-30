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
    ///
    /// 
    /// StackViews
    @IBOutlet private var hoursInfoStackView: UIStackView!
    @IBOutlet var weekInfoStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
