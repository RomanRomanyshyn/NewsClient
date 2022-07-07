//
//  WKWebView+Extension.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
