//
//  DetailView.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import UIKit
import WebKit

final class DetailView: UIViewController, ViewProtocol {
    
    // MARK: - Typealiases
    
    typealias Presenter = DetailPresenterProtocol
    
    // MARK: - Properties

    var presenter: Presenter!
    
    let webView = WKWebView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.onViewDidLoad()
    }
}

// MARK: - DetailViewProtocol

extension DetailView: DetailViewProtocol {
    
}
