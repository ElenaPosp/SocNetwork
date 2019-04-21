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
    
    override func viewDidLoad() {
        let profVC = ProfileViewController()
        profVC.navDelegate = self
        profVC.profile = DataProviders.shared.usersDataProvider.currentUser()
        self.addChildViewController(profVC)
    }
}

extension ProfileNavigationViewController: ProfileViewControllerDelegate {
    func didSelectFollowers() {
        print("sdsdc")
    }
    
    func didSelectFollowered() {
        print("sdcsd")
    }
    
    
}
