//
//  LoadingProvider.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 29/06/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class Loading {
    static var isLoading = false
    static let anim: UIActivityIndicatorView = {
        let frame = CGRect(origin: CGPoint(x: loadindView.center.x, y: loadindView.center.y),
                           size: CGSize(width: 1, height: 1))
        let indicator = UIActivityIndicatorView(frame: frame )
        return indicator
    }()
    
    static var loadindView: UIView = {
        guard let window = UIApplication.shared.windows.first else { fatalError() }
        let a = UIView(frame: window.frame)
        a.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        return a
    }()

    static func start() {
        UIApplication.shared.keyWindow!.addSubview(loadindView)
        loadindView.addSubview(anim)
        anim.startAnimating()
    }

    static func stop() {
        anim.stopAnimating()
        loadindView.removeFromSuperview()
    }
}
