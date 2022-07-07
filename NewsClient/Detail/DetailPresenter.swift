//
//  DetailPresenter.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import Foundation

final class DetailPresenter: PresenterProtocol {
    
    // MARK: - TypeAliases
    
    typealias View = DetailViewProtocol
    typealias Parameters = String
    
    // MARK: - Properties
    
    weak var view: View?
    private var stringURL: String
    
    // MARK: - Init
    
    init(parameters: String, view: View) {
        self.view = view
        self.stringURL = parameters
    }
    
    // MARK: - Public
    
    func onViewDidLoad() {
        view?.webView.load(stringURL)
    }
}

// MARK: - DetailPresenterProtocol

extension DetailPresenter: DetailPresenterProtocol {
    
}
