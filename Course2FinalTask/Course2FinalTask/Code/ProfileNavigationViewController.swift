//
//  ProfileNavigationViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 13/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


protocol ProfileFirstCellDelegate {

    func didTapFollowers(userID id: User.Identifier)
    func didTapFollowing(userID id: User.Identifier)
}

class ProfileNavigationViewController: UINavigationController {

}

extension ProfileNavigationViewController: ProfileFirstCellDelegate {
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

extension ProfileNavigationViewController: UsersListDelegare {
    func openPrifile(withID id: User.Identifier) {
        let vc = ProfileViewController()
        guard let user = DataProviders.shared.usersDataProvider.user(with: id) else { return }
        vc.profile = user
        vc.navDelegate = self
        self.pushViewController(vc, animated: true)
    }
    
    
}
