//
//  UIViewController+extensions.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 26/07/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    var topBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height + navBarHeight
    }
    
    var navBarHeight: CGFloat {
        return navigationController?.navigationBar.frame.height ?? 0
    }
    
    var bottomBarHeight: CGFloat {
        return tabBarController?.tabBar.frame.height ?? 0
    }
}

extension UIViewController {
    
    func showLoadingError() {
        
        let ac = UIAlertController(title: "Unknown error!",
                                   message: "Please, try again later.",
                                   preferredStyle: .alert)

        let action = UIAlertAction(title: "Ok", style: .cancel)
        ac.addAction(action)
        loagingProvider.stop()
        present(ac, animated: true, completion: nil)
    }
}
