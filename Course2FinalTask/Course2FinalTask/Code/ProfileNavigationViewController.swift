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
        let action: ()->() = { [weak self] in
            vc.navigationItem.title = "Followers"
            self?.pushViewController(vc, animated: true)
        }
        DataProviders.shared.usersDataProvider.usersFollowingUser(with: id,
                                                                  queue: QProvider.gueue())
        {
            vc.users = $0 ?? []
            DispatchQueue.main.async { action() }

        }

    }
    
    func didTapFollowing(userID id: User.Identifier) {
        let vc = UsersListViewController()
        vc.delegate = self
        let action: ()->() = { [weak self] in
            vc.navigationItem.title = "Following"
            self?.pushViewController(vc, animated: true)
        }
        
        DataProviders.shared.usersDataProvider.usersFollowedByUser(with: id,
                                                                   queue: QProvider.gueue())
       {
            vc.users = $0 ?? []
            DispatchQueue.main.async { action() }
        }
    }
}

extension ProfileNavigationViewController: UsersListDelegare {

    func openProfile(withID id: User.Identifier) {
        let vc = ProfileViewController()
        
        let action: ()->() = { [weak self] in
            vc.delegate = self
            self?.pushViewController(vc, animated: true)
        }
        DataProviders.shared.usersDataProvider.user(with: id, queue: QProvider.gueue()) {
            vc.profile = $0
            DispatchQueue.main.async { action() }
        }
    }
}
