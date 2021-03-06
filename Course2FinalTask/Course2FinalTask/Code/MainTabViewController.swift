
//
//  MainTabViewController.swift
//  Course2FinalTask
//
//  Created by Елена on 12/04/2019.
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
        addPhotoVC.delegate = navAddPhotoVC

        navFeedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "feed"), tag: 1)
        navAddPhotoVC.tabBarItem = UITabBarItem(title: "Add", image: UIImage(named: "plus"), tag: 2)
        navProfileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 3)

        DataProviders.shared.usersDataProvider.currentUser(queue: QProvider.gueue()) {
            guard let user = $0 else { self.showLoadingError();  return }
            loagingProvider.currentUserId = user.id
            profileVC.profile = user
            feedVC.currentUser = user
        }

        setViewControllers([navFeedVC,navAddPhotoVC,navProfileVC], animated: true)
    }
}
