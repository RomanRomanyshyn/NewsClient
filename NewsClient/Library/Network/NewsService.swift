//
//  NewsService.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 30.06.2022.
//

import Foundation

enum NewsService {
    case search(string: String, page: Int)
    case headline(page: Int)
        
    private enum Constants {
        static let apiKey = "584295943f8f4dfc908ff0451be6c375"
        static let secondApiKey = "3aa890f65545423ea14f6c5c9abbcf00"
        static let thirdApiKey = "df9a7a88ddb24b6d9b52e9bccec6c2df"
        static let pageSize = 10
    }
}

extension NewsService: Service {
    var baseURL: String {
        "https://newsapi.org"
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v2/everything"
        case .headline:
            return "/v2/top-headlines"
        }
    }
    
    var parameters: [String: String] {
        var parameters: [String: String] = [
            "apiKey": Constants.thirdApiKey,
            "pageSize": Constants.pageSize.description
        ]
        switch self {
        case .search(let string, let page):
            parameters["q"] = string
            parameters["page"] = page.description
        case .headline(let page):
            parameters["page"] = page.description
            parameters["language"] = "en"
        }
        return parameters
    }
    
    var method: ServiceMethod {
        .get
    }
}
