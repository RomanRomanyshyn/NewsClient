//
//  NewsResponse.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 30.06.2022.
//

import Foundation
import RealmSwift

// MARK: - NewsResponse

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article

final class Article: Object, Codable {
    @objc dynamic var source: Source?
    @objc dynamic var author: String?
    @objc dynamic var title: String?
    @objc dynamic var shortDescription: String?
    @objc dynamic var url: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var publishedAt: String?
    @objc dynamic var content: String?
    
    enum CodingKeys: String, CodingKey {
        case shortDescription = "description"
        case source, author, title, url, urlToImage, publishedAt, content
    }
    
    override class func primaryKey() -> String? {
        "url"
    }
}

// MARK: - Source

final class Source: Object, Codable {
    @objc dynamic var id: String?
    @objc dynamic var name: String?
}
