//
//  HomeViewController.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 30.06.2022.
//

import UIKit

final class HomeView: UIViewController, ViewProtocol {
    
    // MARK: - Typealiases
    
    typealias Presenter = HomePresenterProtocol
    
    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties

    var presenter: Presenter!
    let refreshControl = UIRefreshControl()

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.onViewDidLoad()
        configureSearch()
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.onViewWillAppear()
    }
    
    // MARK: - Private
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        presenter.refresh()
    }
    
    private func configureSearch() {
        let controller = UISearchController(searchResultsController: nil)
        navigationItem.searchController = controller
        controller.searchResultsUpdater = self
    }
}

// MARK: - HomeViewProtocol

extension HomeView: HomeViewProtocol {
    func push(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

// MARK: - UISearchResultsUpdating

extension HomeView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
        !text.isEmpty else { return }
        presenter.search(text, page: 1)
    }
}

