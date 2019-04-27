//
//  FeedNavigationViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 13/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedNavigationViewController: UINavigationController {

}

extension FeedNavigationViewController: FeedCellDelegate {

    func didTapLikesCount(postID: Post.Identifier) {
        let vc = UsersListViewController()
        vc.delegate = self
        let users = DataProviders.shared.postsDataProvider.usersLikedPost(with: postID)?.compactMap({
            DataProviders.shared.usersDataProvider.user(with: $0)
        })
        vc.users = users ?? []
        self.pushViewController(vc, animated: true)
    }

    func didTapAuthorAvatar(withID id: User.Identifier) {
        let vc = ProfileViewController()
        guard let user = DataProviders.shared.usersDataProvider.user(with: id) else { return }
        vc.profile = user
        vc.delegate = self
        self.pushViewController(vc, animated: true)
    }
}

extension FeedNavigationViewController: ProfileFirstCellDelegate {

    func didTapFollowers(userID id: User.Identifier) {
        let vc = UsersListViewController()
        vc.delegate = self
        vc.users = DataProviders.shared.usersDataProvider.usersFollowingUser(with: id) ?? []
        self.pushViewController(vc, animated: true)
    }
    
    func didTapFollowing(userID id: User.Identifier) {
        let vc = UsersListViewController()
        vc.delegate = self
        vc.users = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: id) ?? []
        self.pushViewController(vc, animated: true)
    }
}

extension FeedNavigationViewController: UsersListDelegare {

    func openProfile(withID id: User.Identifier) {
        let vc = ProfileViewController()
        guard let user = DataProviders.shared.usersDataProvider.user(with: id) else { return }
        vc.profile = user
        vc.delegate = self
        self.pushViewController(vc, animated: true)
    }
}
