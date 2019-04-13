
//
//  MainTabViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 12/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setup()
    }
    
    func setup() {
        
        let feedVC = FeedNavigationViewController()
        let profileVC = ProfileNavigationViewController()
        
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "feed"), tag: 1)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 2)
        self.setViewControllers([feedVC,profileVC], animated: true)
    }
}

