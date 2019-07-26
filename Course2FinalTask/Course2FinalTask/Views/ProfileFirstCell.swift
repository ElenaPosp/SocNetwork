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
    
    @IBAction func followButtonTapped(_ sender: Any) {
        guard let id = userID else { return }
        loagingProvider.start()
        if wantFollow {

            DataProviders.shared.usersDataProvider.follow(id, queue: QProvider.gueue()) { [weak self] in
                if let _ = $0 {
                    self?.updateButton(isFollowing: self?.wantFollow ?? false)
                } else {
                    self?.delegate?.showError()
                }
                loagingProvider.stop()
            }
        } else {

            DataProviders.shared.usersDataProvider.unfollow(id, queue: QProvider.gueue()) { [weak self] in
                if let _ = $0 {
                    self?.updateButton(isFollowing: self?.wantFollow ?? false)
                } else {
                    self?.delegate?.showError()
                }
                loagingProvider.stop()
            }
        }
        
        print(wantFollow)
    }

    var delegate: ProfileFirstCellDelegate?
    var userID: User.Identifier? {
        didSet {
            setupFollowButton()
        }
    }
    private var wantFollow: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInteractive()
    }

    func setupInteractive() {
        
        followersLabel.isUserInteractionEnabled = true
        let g1 = UITapGestureRecognizer(target: self, action: #selector(didTapFollowers))
        followersLabel.addGestureRecognizer(g1)
        
        followingLabel.isUserInteractionEnabled = true
        let g2 = UITapGestureRecognizer(target: self, action: #selector(didTapFollowing))
        followingLabel.addGestureRecognizer(g2)
    }

    func setupFollowButton() {
        followButton.isHidden = true
        if userID == loagingProvider.currentUserId { return }
        loagingProvider.start()
        followButton.layer.cornerRadius = 5
        followButton.contentEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 6)
        followButton.titleLabel?.font = .systemFont(ofSize: 15)
        followButton.titleLabel?.adjustsFontSizeToFitWidth = true
        DataProviders.shared.usersDataProvider.usersFollowingUser(with: userID!,
                                                                  queue: QProvider.gueue()) { [weak self ] followers in
            let users = followers ?? []
            let isFollowing = users.contains { $0.id  == loagingProvider.currentUserId }
            self?.updateButton(isFollowing: isFollowing)
        }
    }

    private func updateButton(isFollowing: Bool) {
        var title = "Follow"
        if isFollowing { title = "Unfollow" }
        wantFollow = !isFollowing
        DispatchQueue.main.async { [weak self] in
            self?.followButton.isHidden = false
            self?.followButton.setTitle(title, for: .normal)
            loagingProvider.stop()
        }
    }
    @objc func didTapFollowers() {
        guard let id = userID else { return }
        delegate?.didTapFollowers(userID: id)
    }
    
    @objc func didTapFollowing() {
        guard let id = userID else { return }
        delegate?.didTapFollowing(userID: id)
    }
}
