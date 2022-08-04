//
//  LoaderView.swift
//  weather
//
//  Created by Kito on 8/4/22.
//

import UIKit

class LoaderView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func start(title: String) {
        titleLabel.text = title
        activityIndicator.startAnimating()
    }
    
    func stop() {
        activityIndicator.stopAnimating()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LoaderView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
