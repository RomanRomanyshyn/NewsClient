//
//  ImageDownloader+Cache.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import UIKit

final class ImageDownloader {
    
    static let shared = ImageDownloader()
    
    private let imageDataHelper = ImageDataHelper.shared
    
    private init() {}

    func fetchImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        let queue = DispatchQueue.global(qos: .background)
        
        queue.async { [weak self] in
            guard let url = url else {
                print("Bad URL")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            if let cachedImage = self?.imageDataHelper.fetchImageFromDatabase(from: url),
               let image = self?.imageDataHelper.fetchImageFromFile(from: URL(string: cachedImage.filepath)) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                self?.downloadImage(from: url) { image in
                    completion(image)
                }
            }
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                print("There is no image")
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                ImageDataHelper.shared.save(image, url)
                completion(image)
            }
        }
        dataTask.resume()
    }
}
