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
    override func viewDidLoad() {
        let feedVC = FeedViewController()
        feedVC.navDelegate = self
        self.addChildViewController(feedVC)
    }
}

extension FeedNavigationViewController: FeedCellDelegate {
    func didTapLikesCount(postID: Post.Identifier) {
        let vc = UsersListViewController()
        let userss = DataProviders.shared.postsDataProvider.usersLikedPost(with: postID)?.compactMap({
            DataProviders.shared.usersDataProvider.user(with: $0)
        })
        vc.users = userss ?? []
        
        self.pushViewController(vc, animated: true)
    }

    func didTapAuthorAvatar(withID ID: User.Identifier) {
        let vc = ProfileViewController()
        guard let user = DataProviders.shared.usersDataProvider.user(with: ID) else { return }
        vc.profile = user
        vc.navDelegate = self
        self.pushViewController(vc, animated: true)
    }

    func didLikePhoto() {
        
    }
}

extension FeedNavigationViewController: ProfileFirstCellDelegate {

    func didTapFollowers(userID id: User.Identifier) {
        let vc = UsersListViewController()
        vc.users = DataProviders.shared.usersDataProvider.usersFollowingUser(with: id) ?? []
        self.pushViewController(vc, animated: true)
    }
    
    func didTapFollowing(userID id: User.Identifier) {
        let vc = UsersListViewController()
        vc.users = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: id) ?? []
        self.pushViewController(vc, animated: true)
    }
}
