//
//  AddPhotoNavigationViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 29/06/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class AddPhotoNavigationViewController: UINavigationController {
}

extension AddPhotoNavigationViewController: AddPhotoDelegate {

    func didSelectPhoto(atIndex index: Int) {
        let vc = FiltersViewController()
        vc.title = "Filters"
        vc.targetImageIndex = index
        pushViewController(vc, animated: true)
    }
}
