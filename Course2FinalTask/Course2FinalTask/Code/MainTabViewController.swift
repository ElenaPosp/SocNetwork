
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
        setup()
    }
    
    func setup() {
        let feedVC = FeedNavigationViewController()
        let profileVC = ProfileNavigationViewController()
      
        let profileTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        profileTitle.textAlignment = .center
        profileTitle.text = "Profile"
        profileVC.navigationBar.addSubview(profileTitle)
        
            
        let feddTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        feddTitle.textAlignment = .center
        feddTitle.text = "Feed"
        feedVC.navigationBar.addSubview(feddTitle)
            
        
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "feed"), tag: 1)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 2)
        self.setViewControllers([feedVC,profileVC], animated: true)
    }
}

