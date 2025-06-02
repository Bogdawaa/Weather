//
//  SceneDelegate.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 28.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        var presenter: MainPresenter = MainPresenterImpl()
        let vc = MainViewController(presenter: presenter)
        presenter.view = vc
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
