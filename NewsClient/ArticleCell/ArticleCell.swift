//
//  ArticleCell.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 30.06.2022.
//

import UIKit
import RealmSwift

final class ArticleCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var shortDescription: UILabel!
    @IBOutlet private weak var source: UILabel!
    @IBOutlet private weak var likeButton: LikeButton!
    
    // MARK: - Properties
    
    private weak var delegate: LikeDelegate?
    
    // MARK: - Private
    
    func configure(with article: Article, isLiked: Bool, delegate: LikeDelegate) {
        title.text = article.title
        shortDescription.text = article.shortDescription
        source.text = article.source?.name
        author.text = article.author
        likeButton.isLiked = isLiked
        self.delegate = delegate
    }
    
    func setImage(_ image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.articleImageView.image = image
        }
    }
    
    // MARK: - IBAction
    
    @IBAction private func likeButtonDidTap(_ sender: LikeButton) {
        delegate?.likeButtonDidPress(in: self, sender: sender)
    }
}

final class LikeButton: UIButton {
    
    // MARK: - Properties
    
    var isLiked = false {
        didSet {
            setStatus()
        }
    }
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setStatus()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStatus()
    }
    
    // MARK: - Private
    
    private func setStatus() {
        isLiked ? like() : dislike()
    }
    
    private func like() {
        setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    private func dislike() {
        setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func changeState() {
        isLiked = !isLiked
    }
}

protocol LikeDelegate: AnyObject {
    func likeButtonDidPress(in cell: UITableViewCell, sender: LikeButton)
    func objectDidUnLike(_ object: Object)
}

extension LikeDelegate {
    func objectDidUnLike(_ object: Object) {}
}
