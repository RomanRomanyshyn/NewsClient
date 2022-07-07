//
//  FavouritesPresenter.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import UIKit
import RealmSwift

final class FavouritesPresenter: NSObject, PresenterProtocol {
    
    // MARK: - Typealiases
    
    typealias View = FavouritesViewProtocol
    typealias Parameters = Void
    
    // MARK: - Properties
    
    weak var view: View?

    private var dataSource = [(article: Article, image: UIImage?)]()

    private let realmManager = RealmManager.shared
    private lazy var likeManager = LikeManager(delegate: self)
    
    // MARK: - Constants
    
    private enum Constants {
        static let cellType = ArticleCell.self
    }
    
    // MARK: - Init
    
    init(parameters: Void, view: View) {
        self.view = view
    }
    
    // MARK: - Private
    
    private func preparePlaceholder() {
        view?.placeholderView.isHidden = !dataSource.isEmpty
    }
    
    private func prepareTableView() {
        view?.tableView.registerCell(Constants.cellType)
        view?.tableView.delegate = self
        view?.tableView.dataSource = self
    }
    
    private func loadFavourites() {
        guard let articles = realmManager.objects(Article.self) else { return }
        dataSource = Array(articles).compactMap({ (article: $0, image: nil) })
        view?.tableView.reloadData()
        loadImages()
    }
    
    private func loadImages() {
                
        for index in .zero..<dataSource.count {
            guard dataSource[index].image == nil else {
                continue
            }
            guard let stringURL = dataSource[index].article.urlToImage,
                    let url = URL(string: stringURL) else {
                self.dataSource[index].image = UIImage()
                continue
            }
            ImageDownloader.shared.fetchImage(from: url) { [weak self] downloadedImage in
                self?.dataSource[index].image = downloadedImage
                DispatchQueue.main.async {
                    self?.view?.tableView.reloadRows(at: [IndexPath(row: index, section: .zero)], with: .none)
                }
            }
        }
    }
    
    // MARK: - Public
    
    func onViewDidLoad() {
        prepareTableView()
    }
    
    func onViewWillAppear() {
        loadFavourites()
        preparePlaceholder()
    }
}

// MARK: - FavouritesPresenterProtocol

extension FavouritesPresenter: FavouritesPresenterProtocol {
    
}

// MARK: - TableView Methods

extension FavouritesPresenter: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(class: Constants.cellType, for: indexPath) else { return UITableViewCell() }
        
        let article = dataSource[indexPath.row].article
        let isLiked = likeManager.isLiked(object: article)
        cell.configure(with: article, isLiked: isLiked, delegate: self)
        cell.setImage(dataSource[indexPath.row].image)
        return cell
    }
}

// MARK: - Like Delegate

extension FavouritesPresenter: LikeDelegate {
    func likeButtonDidPress(in cell: UITableViewCell, sender: LikeButton) {
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
        let article = dataSource[indexPath.row].article
        likeManager.changeLikedState(for: article, sender: sender)
    }
    
    func objectDidUnLike(_ object: Object) {
        guard let row = dataSource.firstIndex(where: { $0.article == object }) else { return }
        dataSource.remove(at: row)
        view?.tableView.deleteRows(at: [IndexPath(row: row, section: .zero)], with: .left)
        preparePlaceholder()
    }
}
