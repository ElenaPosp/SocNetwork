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
    func didSelectPhoto(_ img: UIImage) {
        
        let vc = FiltersViewController()
        vc.delegate = self
        vc.title = "Filters"
        vc.targetImage = img
        pushViewController(vc, animated: true)
    }
}

extension AddPhotoNavigationViewController: FiltersDelegate {
    
}
