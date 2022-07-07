//
//  HomeViewProtocols.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 30.06.2022.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    var tableView: UITableView! { get }
    func endRefreshing()
    func push(_ controller: UIViewController)
}

protocol HomePresenterProtocol: BasePresenterProtocol {
    func search(_ string: String, page: Int)
    func refresh()
}
