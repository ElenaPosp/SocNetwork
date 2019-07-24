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
    var currentUser: User?
    let postsProvider = DataProviders.shared.postsDataProvider
    let usersProvider = DataProviders.shared.usersDataProvider

    var postID: Post.Identifier? {
        didSet {
            setupLikesCount()
            loagingProvider.stop()
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
       
        guard let id = postID else { return }
        DispatchQueue.main.async { loagingProvider.start() }
        postsProvider.post(with: id, queue: QProvider.gueue()) {
            guard let authtorID = $0?.author else { return }
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didTapAuthorAvatar(withID: authtorID)
            }
        }
    }

    @objc func didTaplike(){
        addLike()
    }

    @objc func didTapBiglike(){
        playLikeAnimation()
        addLike()
    }
    
    @objc func didTapLikesCount() {
        guard let postID = postID else { return }
        delegate?.didTapLikesCount(postID: postID)
    }
    
    private func playLikeAnimation() {

        let anim = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.values = [0,1,1,0]
        anim.keyTimes = [0, 0.33, 0.66, 1]
        anim.duration = 0.3
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.isAdditive = true
        bigLikeImageView.layer.add(anim, forKey: "opacity")
    }
    
    private func addLike() {
        guard let id = postID else { return }

        postsProvider.usersLikedPost(with: id, queue: QProvider.gueue()) { [weak self] in
            self?.setupLike($0, id: id)
            self?.updateLikesCount()
        }
    }

    private func setupLike(_ users: [User]?, id: Post.Identifier) {
        if (users?.contains { $0.id == currentUser?.id }) ?? false {
            postsProvider.unlikePost(with: id, queue: QProvider.gueue()) { _ in
                DispatchQueue.main.async { [weak self] in
                    self?.likeImageView.tintColor = .lightGray
                    self?.updateLikesCount()
                }
            }

        } else {
            postsProvider.likePost(with: id, queue: QProvider.gueue()) { _ in
                DispatchQueue.main.async { [weak self] in
                    self?.likeImageView.tintColor = self?.tintColor
                    self?.updateLikesCount()
                }
            }
        }
    }
    
    private func setupLikesCount() {
        guard let id = postID else { return }

        postsProvider.post(with: id, queue: QProvider.gueue()) { post in
            let oper = BlockOperation { [weak self] in
                self?.likesLabel.text = "Likes: \(post?.likedByCount ?? 0)"
            }

            if let mainOper = loagingProvider.mainFeedOperation {
                oper.addDependency(mainOper)
            }
            loagingProvider.operationQueue.addOperation(oper)
        }
    }

    private func updateLikesCount() {
        guard let id = postID else { return }
        postsProvider.post(with: id, queue: QProvider.gueue()) { post in
            DispatchQueue.main.async { [weak self] in
                self?.likesLabel.text = "Likes: \(post?.likedByCount ?? 0)"
            }
        }
    }
}

