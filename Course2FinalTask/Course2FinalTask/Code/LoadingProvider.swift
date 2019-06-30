//
//  LoadingProvider.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 29/06/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

let loagingProvider = Loading()

class Loading {
    var isLoading = false
    let anim: UIActivityIndicatorView

    var loadindView: UIView = {
        guard let window = UIApplication.shared.windows.first else { fatalError() }
        let a = UIView(frame: window.frame)
        a.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return a
    }()

    init() {
        let frame = CGRect(origin: CGPoint(x: loadindView.center.x, y: loadindView.center.y),
                           size: CGSize(width: 1, height: 1))
        anim = UIActivityIndicatorView(frame: frame)
    }

    func start() {
        guard
            !isLoading,
            let window = UIApplication.shared.keyWindow
        else { return }

        window.addSubview(loadindView)
        loadindView.addSubview(anim)
        anim.startAnimating()
        isLoading = true
    }

    func stop() {
        guard isLoading else { return }
        anim.stopAnimating()
        loadindView.removeFromSuperview()
        isLoading = false
    }

    var mainFeedOperation: BlockOperation?
    let operationQueue = OperationQueue.main
    func executeFeedOperation() {
        guard let oper = mainFeedOperation else { return }
        operationQueue.addOperation(oper)
    }
}
