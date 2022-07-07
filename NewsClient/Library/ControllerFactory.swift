//
//  ControllerFactory.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import UIKit

final class ControllerFactory {
    static func home() -> HomeView {
        let view: HomeView = UIStoryboard.main.instantiateViewController()
        let presenter = HomePresenter(parameters: (), view: view)
        view.presenter = presenter
        
        return view
    }
    
    static func favourites() -> FavouritesView {
        let view: FavouritesView = UIStoryboard.main.instantiateViewController()
        let presenter = FavouritesPresenter(parameters: (), view: view)
        view.presenter = presenter
        
        return view
    }
    
    static func detail(_ url: String) -> DetailView {
        let view = DetailView()
        let presenter = DetailPresenter(parameters: (url), view: view)
        view.presenter = presenter
        
        return view
    }
}
