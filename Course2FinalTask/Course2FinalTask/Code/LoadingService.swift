//
//  LoadingService.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 29/06/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class QProvider {

    static func gueue() -> DispatchQueue {
        return DispatchQueue.global()
    }
}

let loagingProvider = LoadingService()

class LoadingService {
    
    private let lock = NSLock()
    private var boolLoading = false
    private let activityIndicator: UIActivityIndicatorView

    var currentUserId: User.Identifier?

    var isLoading: Bool {
        get { return self.boolLoading }
        set {
            lock.lock()
            self.boolLoading = newValue
            lock.unlock()
        }
    }

    private var loadindView: UIView = {
        guard let window = UIApplication.shared.windows.first else { fatalError() }
        let a = UIView(frame: window.frame)
        a.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return a
    }()

    init() {
        let frame = CGRect(origin: CGPoint(x: loadindView.center.x, y: loadindView.center.y),
                           size: CGSize(width: 1, height: 1))
        activityIndicator = UIActivityIndicatorView(frame: frame)
    }

    func start() {
        if Thread.isMainThread {
            syncStart()
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.syncStart()
        }
    }

    func stop() {
        if Thread.isMainThread {
            syncStop()
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.syncStop()
        }
    }

    private func syncStart() {
        guard
            !isLoading,
            let window = UIApplication.shared.keyWindow
        else { return }
        isLoading = true
        window.addSubview(loadindView)
        loadindView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    private func syncStop() {
        guard isLoading else { return }
        activityIndicator.stopAnimating()
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

