//
//  DescriptionViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 23/07/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class DescriptionViewController: UIViewController {

    var originHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height + navBarHeight
    }

    var navBarHeight: CGFloat {
        return navigationController?.navigationBar.frame.height ?? 0
    }

    var image: UIImage?

    lazy var imageView: UIImageView = {
        let point = CGPoint(x:  16, y: originHeight + 16)
        let frame = CGRect(origin: point, size: CGSize(width: 100, height: 100))
        let a = UIImageView(frame: frame)
        a.backgroundColor = .red
        return a
    }()

    lazy var label: UILabel = {
        let point = CGPoint(x:  16, y: imageView.frame.maxY + 32)
        var a = UILabel(frame: CGRect(origin: point, size: CGSize(width: view.frame.size.width - 32, height: 19)))
        a.font = UIFont.systemFont(ofSize: 17)
        a.text = "Add description:"
        return a
    }()

    lazy var textField: UITextField = {
        let point = CGPoint(x:  16, y: label.frame.maxY + 8)
        let a = UITextField(frame: CGRect(origin: point, size: CGSize(width: view.frame.size.width - 32, height: 32)))
        a.contentMode = .scaleAspectFit
        a.layer.borderWidth = 1
        a.layer.borderColor = UIColor.lightGray.cgColor
        a.layer.cornerRadius = 5
        return a
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(textField)
        setupShareButton()
    }
    
    private func setupShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(shareTapped))
    }
    
    @objc func shareTapped() {
//        DataProviders.shared.postsDataProvider
    }
}
