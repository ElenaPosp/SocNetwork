//
//  ProfileFirstCell.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 15/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


protocol ProfileFirstCellDelegate {
    
    func didTapFollowers(userID id: User.Identifier)
    func didTapFollowing(userID id: User.Identifier)
    func showError()
}

class ProfileFirstCell: UICollectionViewCell {
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var delegate: ProfileFirstCellDelegate?
    var user: User? {
        didSet {
            setupButton()
        }
    }
    
    private var wantFollow: Bool = true
    
    @IBAction func followButtonTapped(_ sender: Any) {
        guard let id = user?.id else { return }
        loagingProvider.start()

        if wantFollow {
            DataProviders.shared.usersDataProvider.follow(id, queue: QProvider.gueue()) { [weak self] in
               self?.finishFollowing($0)
            }
        } else {
            DataProviders.shared.usersDataProvider.unfollow(id, queue: QProvider.gueue()) { [weak self] in
                self?.finishFollowing($0)
            }
        }
    }

    func finishFollowing(_ user: User?) {
        if let _ = user {
            update(isFollowing: wantFollow)
        } else {
            loagingProvider.stop()
            delegate?.showError()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInteractive()
        setupElements()
    }

    func setupInteractive() {
        
        followersLabel.isUserInteractionEnabled = true
        let g1 = UITapGestureRecognizer(target: self, action: #selector(didTapFollowers))
        followersLabel.addGestureRecognizer(g1)
        
        followingLabel.isUserInteractionEnabled = true
        let g2 = UITapGestureRecognizer(target: self, action: #selector(didTapFollowing))
        followingLabel.addGestureRecognizer(g2)
    }

    func setupElements() {
        userNameLabel.text = user?.fullName
        followingLabel.text = "Following: \(user?.followsCount ?? 0)"
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2

    }

    func setupButton() {
        followButton.isHidden = true
        guard
            let id = user?.id,
            user?.id != loagingProvider.currentUserId
        else { return }

        loagingProvider.start()
        followButton.layer.cornerRadius = 5
        followButton.contentEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 6)
        followButton.titleLabel?.font = .systemFont(ofSize: 15)
        DataProviders.shared.usersDataProvider.usersFollowingUser(with: id, queue: QProvider.gueue()) { [weak self ] followers in
            let users = followers ?? []
            let isFollowing = users.contains { $0.id  == loagingProvider.currentUserId }
            self?.update(isFollowing: isFollowing)
        }
    }

    private func update(isFollowing: Bool) {
        guard let id = user?.id else { return }
        var title = "Follow"
        if isFollowing { title = "Unfollow" }
        wantFollow = !isFollowing

        DataProviders.shared.usersDataProvider.user(with: id, queue: QProvider.gueue()) {
            guard let followers = $0?.followedByCount else { return }
            DispatchQueue.main.async { [weak self] in
                self?.followersLabel.text = "Followers: \(followers)"
                self?.followButton.isHidden = false
                self?.followButton.setTitle(title, for: .normal)
                loagingProvider.stop()
            }
        }
    }

    @objc func didTapFollowers() {
        guard let id = user?.id else { return }
        delegate?.didTapFollowers(userID: id)
    }
    
    @objc func didTapFollowing() {
        guard let id = user?.id else { return }
        delegate?.didTapFollowing(userID: id)
    }
}
