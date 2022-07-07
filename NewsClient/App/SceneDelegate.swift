//
//  SceneDelegate.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 30.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [getFirstTab(), getSecondTab()]
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func getFirstTab() -> UIViewController {
        let navigation = UINavigationController()
        navigation.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 1)
        let home = ControllerFactory.home()
        navigation.pushViewController(home, animated: true)
        return navigation
    }
    
    private func getSecondTab() -> UIViewController {
        let navigation = UINavigationController()
        navigation.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "heart"), tag: 2)
        let home = ControllerFactory.favourites()
        navigation.pushViewController(home, animated: true)
        return navigation
    }
}

