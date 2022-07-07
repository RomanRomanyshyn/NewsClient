//
//  ImageDataHelper.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import UIKit

final class ImageDataHelper {
    
    static let shared = ImageDataHelper()
    
    // MARK: - Properties
    
    private let realmManager = RealmManager.shared
        
    private var uniqueKeyForPath: String {
        let timeInterval = Date().timeIntervalSinceReferenceDate
        return String(timeInterval)
    }
    
    // MARK: - Init
    
    private init() {}
        
    // MARK: - Private
    
    private func uniqueFilePath() -> URL? {
        let url = try? FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(uniqueKeyForPath + ".png")
        return url
    }
    
    private func saveCache(filepath: URL, url: URL) {
        if let image = fetchImageFromDatabase(from: url) {
            realmManager.runTransaction {
                image.filepath = filepath.relativeString
            }
        } else {
            let imageInstance = ImageRealm.create(url: url, filepath: filepath)
            realmManager.add(imageInstance)
        }
    }
    
    private func saveImageInFile(image: UIImage) -> URL? {
        guard let pngRepresentation = image.pngData() else { return nil }
        guard let filePath = uniqueFilePath() else { return nil }
        do {
            try pngRepresentation.write(to: filePath, options: .atomic)
            return filePath
        } catch let err {
            print("Saving file resulted in error: ", err)
            return nil
        }
    }
    
    // MARK: - Public
    
    func save(_ image: UIImage, _ url: URL) {
        guard let filePath = saveImageInFile(image: image) else { return }
        saveCache(filepath: filePath, url: url)
    }
    
    func fetchImageFromFile(from filePath: URL?) -> UIImage? {
        guard let filePath = filePath else { return nil }
        do {
            let imageData = try Data(contentsOf: filePath)
            return UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchImageFromDatabase(from url: URL) -> ImageRealm? {
        realmManager.object(ImageRealm.self, key: url.relativeString)
    }
}
