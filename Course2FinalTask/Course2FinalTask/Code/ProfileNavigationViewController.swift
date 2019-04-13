//
//  ProfileNavigationViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 13/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class ProfileNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        self.addChild(ProfileViewController())
    }
}
