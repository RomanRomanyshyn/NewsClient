//
//  DetailProtocols.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import Foundation
import WebKit

protocol DetailViewProtocol: AnyObject {
    var webView: WKWebView { get }
}

protocol DetailPresenterProtocol: BasePresenterProtocol {
}
