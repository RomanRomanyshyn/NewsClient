//
//  FavouritesView.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import UIKit

final class FavouritesView: UIViewController, ViewProtocol {
    
    // MARK: - Typealiases
    
    typealias Presenter = FavouritesPresenterProtocol
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    
    // MARK: - Properties
    
    var presenter: Presenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.onViewWillAppear()
    }
}

// MARK: - FavouritesViewProtocol

extension FavouritesView: FavouritesViewProtocol {
    
}
