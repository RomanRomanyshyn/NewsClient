//
//  LikeManager.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 01.07.2022.
//

import UIKit
import RealmSwift

final class LikeManager {
    
    // MARK: - Properties
    
    private let realmManager = RealmManager.shared
    private weak var delegate: LikeDelegate?
    
    // MARK: - Init
    
    init(delegate: LikeDelegate? = nil) {
        self.delegate = delegate
    }
    
    // MARK: - Private
    
    private func like<T: Object>(object: T, sender: LikeButton) {
        realmManager.add(object) {
            sender.changeState()
        }
    }
    
    private func unlike<T: Object>(object: T, sender: LikeButton) {
        showAlert(removeAction: { [weak self] _ in
            self?.realmManager.delete(object) {
                sender.changeState()
                self?.delegate?.objectDidUnLike(object)
            }
        })
    }
    
    private func showAlert(removeAction: @escaping ((UIAlertAction) -> Void)) {
        let alertController = UIAlertController.getUnlikedAlert(removeAction: removeAction)
        UIViewController.topMostViewController?.present(alertController, animated: true)
    }
    
    // MARK: - Public
    
    func changeLikedState<T: Object>(for object: T, sender: LikeButton) {
        if sender.isLiked {
            unlike(object: object, sender: sender)
        } else {
            like(object: object, sender: sender)
        }
    }
    
    func isLiked<T: Object>(object: T) -> Bool {
        guard let keyValue = realmManager.getPrimaryValue(for: object) else { return false }
        return realmManager.object(T.self, key: keyValue) != nil
    }
}
