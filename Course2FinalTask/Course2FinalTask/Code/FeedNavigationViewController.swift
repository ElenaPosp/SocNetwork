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
        //
    }

    func didTapAuthorAvatar(withID ID: User.Identifier) {
        let vc = ProfileViewController()
        guard let user = DataProviders.shared.usersDataProvider.user(with: ID) else { return }
        vc.profile = user
        self.pushViewController(vc, animated: true)
    }

    func didLikePhoto() {
        
    }
}
