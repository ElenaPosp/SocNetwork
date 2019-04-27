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

    func didTapAuthorAvatar(withID id: User.Identifier)
    func didTapLikesCount(postID id: Post.Identifier)
}

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var bigLikeImageView: UIImageView!

    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postDescriptionLabel: UILabel!

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    
    var delegate: FeedCellDelegate?
    let postsProvider = DataProviders.shared.postsDataProvider
    let usersProvider = DataProviders.shared.usersDataProvider

    var postID: Post.Identifier? {
        didSet {
            updateLikesCount()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
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
            let id = postID,
            let authtorID = postsProvider.post(with: id)?.author
        else { return }
        delegate?.didTapAuthorAvatar(withID: authtorID)
    }

    @objc func didTaplike(){
        addLike()
    }

    @objc func didTapBiglike(){
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
        guard let id = postID else { return }

        let users = postsProvider.usersLikedPost(with: id)
        if users?.contains(usersProvider.currentUser().id) ?? false {
            likeImageView.tintColor = .lightGray
            _ = postsProvider.unlikePost(with: id)
        } else {
            likeImageView.tintColor = self.tintColor
            _ = postsProvider.likePost(with: id)
        }
        updateLikesCount()
    }

    private func updateLikesCount() {
        guard let id = postID else { return }
        
        let likesCount = postsProvider.post(with: id)?.likedByCount
        likesLabel.text = "Likes: \(likesCount ?? 0)"
    }
}

