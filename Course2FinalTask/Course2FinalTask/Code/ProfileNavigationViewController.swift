//
//  ProfileNavigationViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 13/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


class ProfileNavigationViewController: UINavigationController {

}

extension ProfileNavigationViewController: ProfileFirstCellDelegate {

    func didTapFollowers(userID id: User.Identifier) {
        let vc = UsersListViewController()
        vc.delegate = self
        vc.users = DataProviders.shared.usersDataProvider.usersFollowingUser(with: id) ?? []
        vc.navigationItem.title = "Followers"
        self.pushViewController(vc, animated: true)
    }
    
    func didTapFollowing(userID id: User.Identifier) {
        let vc = UsersListViewController()
        vc.delegate = self
        vc.users = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: id) ?? []
        vc.navigationItem.title = "Following"
        self.pushViewController(vc, animated: true)
    }
}

extension ProfileNavigationViewController: UsersListDelegare {

    func openProfile(withID id: User.Identifier) {
        let vc = ProfileViewController()
        guard let user = DataProviders.shared.usersDataProvider.user(with: id) else { return }
        vc.profile = user
        vc.delegate = self
        self.pushViewController(vc, animated: true)
    }
}
