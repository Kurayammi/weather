//
//  Extentions.swift
//  weather
//
//  Created by Kito on 8/7/22.
//

import Foundation
import UIKit

extension Int {
    func toString() -> String {
        return String(self)
    }
}

extension Double {
    func toInt() -> Int {
        return Int(self)
    }
    
    func toString() -> String {
        return String(self)
    }
}

extension UIViewController {
    func showAlertFor(title: String,
                      message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default:
                print("Unknown Error")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
