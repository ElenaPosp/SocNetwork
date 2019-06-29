//
//  LoadingProvider.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 29/06/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class Loading {
    static let anim: UIActivityIndicatorView = {
        let d = UIActivityIndicatorView(frame: CGRect(origin: CGPoint(x: loadindView.center.x, y: loadindView.center.y), size: CGSize(width: 1, height: 1)))
        
        return d
    }()
    
    static var loadindView: UIView = {
        let a = UIView(frame: UIApplication.shared.windows.first!.frame)
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
