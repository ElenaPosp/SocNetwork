//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 13/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController  {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.frame = (view.superview?.frame)!
    }
}
