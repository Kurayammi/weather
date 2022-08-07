//
//  SceneDelegate.swift
//  weather
//
//  Created by Kito on 7/30/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private var mainCoordinator: MainCoordinator?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        mainCoordinator = MainCoordinator(window: window)
        mainCoordinator?.start()
        
        self.window = window
    }
}
