//
//  FavouritesProtocols.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import UIKit

protocol FavouritesViewProtocol: AnyObject {
    var tableView: UITableView! { get }
    var placeholderView: UIView! { get }
}

protocol FavouritesPresenterProtocol: BasePresenterProtocol {
}
