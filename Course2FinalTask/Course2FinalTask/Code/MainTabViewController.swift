
//
//  MainTabViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 12/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {

        let feedVC = FeedViewController()
        let navFeedVC = FeedNavigationViewController(rootViewController: feedVC)
        feedVC.delegate = navFeedVC
        feedVC.navigationItem.title = "Feed"

        let profileVC = ProfileViewController()
        let navProfileVC = ProfileNavigationViewController(rootViewController: profileVC)
        profileVC.delegate = navProfileVC

        let addPhotoVC = AddPhotoViewController()
        let navAddPhotoVC = AddPhotoNavigationViewController(rootViewController: addPhotoVC)
        addPhotoVC.navigationItem.title = "New post"

        navAddPhotoVC.tabBarItem = UITabBarItem(title: "Add", image: UIImage(named: "plus"), tag: 3)
        navFeedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "feed"), tag: 1)
        navProfileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 2)

        DataProviders.shared.usersDataProvider.currentUser(queue: QProvider.gueue()) {
            profileVC.profile = $0
            feedVC.currentUser = $0
        }

        self.setViewControllers([navFeedVC,navAddPhotoVC,navProfileVC], animated: true)
    }
}

