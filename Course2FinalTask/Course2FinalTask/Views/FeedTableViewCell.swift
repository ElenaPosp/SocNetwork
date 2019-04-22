//
//  FeedTableViewCell.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 14/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

protocol FeedCellDelegate {
    func didTapAuthorAvatar(withID ID: User.Identifier)
    func didLikePhoto()
    func didTapLikesCount(postID: Post.Identifier)
}

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var bigLikeImageView: UIImageView!
    
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    
    var postID: Post.Identifier? {
        didSet {
            updateLikesCount()
        }
    }

    var delegate: FeedCellDelegate?
    let postsProvider = DataProviders.shared.postsDataProvider
    let usersProvider = DataProviders.shared.usersDataProvider

    override func awakeFromNib() {
        super.awakeFromNib()
        bigLikeImageView.layer.opacity = 0
        setupInteractive()
    }
    
    func setupInteractive() {
        
        authorAvatarImageView.isUserInteractionEnabled = true
        let g1 = UITapGestureRecognizer(target: self, action: #selector(didSelectAuthorAvatar))
        authorAvatarImageView.addGestureRecognizer(g1)
        
        likesLabel.isUserInteractionEnabled = true
        let g2 = UITapGestureRecognizer(target: self, action: #selector(didTapLikesCount))
        likesLabel.addGestureRecognizer(g2)
        
        likeImageView.isUserInteractionEnabled = true
        let g3 = UITapGestureRecognizer(target: self, action: #selector(didTaplike))
        likeImageView.addGestureRecognizer(g3)
        
        postImageView.isUserInteractionEnabled = true
        let g4 = UITapGestureRecognizer(target: self, action: #selector(didTapBiglike))
        g4.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(g4)
    }

    @objc func didSelectAuthorAvatar(){
        guard
            postID != nil,
            let authtorID = postsProvider.post(with: postID!)?.author
        else { return }
        delegate?.didTapAuthorAvatar(withID: authtorID)
    }

    @objc func didTaplike(){
        guard postID != nil else { return }
        addLike()
    }

    @objc func didTapBiglike(){
        guard postID != nil else { return }
        playLikeAnimation()
        addLike()
    }
    
    @objc func didTapLikesCount() {
        guard postID != nil else { return }
        delegate?.didTapLikesCount(postID: postID!)
    }
    
    private func playLikeAnimation() {
        let endValue: CGFloat = 1
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.duration = 0.2
        anim.fromValue = 0
        anim.toValue = endValue
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.autoreverses = true
        bigLikeImageView.layer.add(anim, forKey: "opacity")
    }
    
    private func addLike() {
        let users = postsProvider.usersLikedPost(with: postID!)
        if users?.contains(usersProvider.currentUser().id) ?? false {
            likeImageView.tintColor = .lightGray
            _ = postsProvider.unlikePost(with: postID!)
            updateLikesCount()
        } else {
            likeImageView.tintColor = .cyan
            _ = postsProvider.likePost(with: postID!)
            updateLikesCount()
        }
    }

    private func updateLikesCount() {
        guard postID != nil else { return }
        let likesCount = postsProvider.post(with: postID!)?.likedByCount
        likesLabel.text = "Likes: \(likesCount ?? 0)"
    }
}

