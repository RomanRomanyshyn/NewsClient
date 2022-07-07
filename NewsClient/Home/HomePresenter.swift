//
//  HomeViewPresenter.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 30.06.2022.
//

import UIKit
import RealmSwift

final class HomePresenter: NSObject, PresenterProtocol {
    
    // MARK: - Typealiases
    
    typealias View = HomeViewProtocol
    typealias Parameters = Void
    
    // MARK: - Properties
    
    weak var view: View?
    
    private var dataSource = [(article: Article, image: UIImage?)]()

    private var isLoaded = false
    private var lastRequest: NewsService?

    private lazy var provider = ServiceProvider<NewsService>()
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
    
    private func prepareTableView() {
        view?.tableView.registerCell(Constants.cellType)
        view?.tableView.delegate = self
        view?.tableView.dataSource = self
    }
    
    private func loadHeadlines(page: Int) {
        let request: NewsService = .headline(page: page)
        lastRequest = request
        load(request)
    }
    
    private func load(_ service: NewsService, isPaging: Bool = false, completion: @escaping () -> Void = {}) {
        provider.load(service: service,
                      decodeType: NewsResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                if isPaging {
                    self.dataSource += model.articles?.map({(article: $0, image: nil)}) ?? []
                } else {
                    self.dataSource = model.articles?.map({(article: $0, image: nil)}) ?? []
                }
            case .failure(let error):
                print(error)
            case .empty:
                print("Empty")
            }
            self.view?.tableView.reloadData()
            self.loadImages(isPaging: isPaging)
            if isPaging {
                self.isLoaded = false
            }
            completion()
        }
    }
    
    private func loadImages(isPaging: Bool) {
                
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
    
    private func nextPage(completion: @escaping () -> Void = {}) {
        guard let lastRequest = lastRequest else { return }
        let newRequest: NewsService
        switch lastRequest {
        case .headline(let page):
            newRequest = .headline(page: page + 1)
        case .search(let string, let page):
            newRequest = .search(string: string, page: page + 1)
        }
        self.lastRequest = newRequest
        load(newRequest, isPaging: true)
    }
    
    // MARK: - Public
    
    func onViewDidLoad() {
        prepareTableView()
        loadHeadlines(page: 1)
    }
    
    func onViewWillAppear() {
        view?.tableView.reloadData()
    }
}

// MARK: - HomePresenterProtocol

extension HomePresenter: HomePresenterProtocol {
    func refresh() {
        guard let lastRequest = lastRequest else { return }
        let newRequest: NewsService
        switch lastRequest {
        case .headline:
            newRequest = .headline(page: 1)
        case .search(let string, _):
            newRequest = .search(string: string, page: 1)
        }
        self.lastRequest = newRequest
        load(newRequest, isPaging: false) { [weak self] in
            self?.view?.endRefreshing()
        }
    }
    
    func search(_ string: String, page: Int) {
        let request: NewsService = .search(string: string, page: page)
        lastRequest = request
        load(request)
    }
}

// MARK: - TableView methods

extension HomePresenter: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = dataSource[indexPath.row].article.url else { return }
        let detail = ControllerFactory.detail(url)
        view?.push(detail)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
        if pos > (view?.tableView.contentSize.height)! - 50 - scrollView.frame.size.height {
            guard !isLoaded, !dataSource.isEmpty else { return }
            isLoaded = true
            nextPage()
        }
    }
}

// MARK: - Like delegate

extension HomePresenter: LikeDelegate {
    func likeButtonDidPress(in cell: UITableViewCell, sender: LikeButton) {
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
        let article = dataSource[indexPath.row].article
        likeManager.changeLikedState(for: article, sender: sender)
    }
}
