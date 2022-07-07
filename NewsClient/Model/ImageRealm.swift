//
//  ImageRealm.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import Foundation
import RealmSwift

final class ImageRealm: Object {
    @objc dynamic var url = String()
    @objc dynamic var filepath = String()

    static func create(url: URL, filepath: URL) -> ImageRealm {
        let image = ImageRealm()
        image.url = url.relativeString
        image.filepath = filepath.relativeString
        return image
    }
    
    override class func primaryKey() -> String? {
        "url"
    }
}
