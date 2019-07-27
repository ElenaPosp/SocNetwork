//
//  DescriptionViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 23/07/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


protocol DescriptionViewDeledate {
    func photoShared()
}

class DescriptionViewController: UIViewController {

    var image: UIImage?

    lazy var imageView: UIImageView = {
        let frame = CGRect(origin: CGPoint(x:  16, y: topBarHeight + 16),
                           size: CGSize(width: 100, height: 100))
        let view = UIImageView(frame: frame)
        view.image = image
        return view
    }()

    lazy var label: UILabel = {
        let frame = CGRect(origin: CGPoint(x:  16, y: imageView.frame.maxY + 32),
                           size: CGSize(width: view.frame.size.width - 32, height: 19))
        let label = UILabel(frame: frame)
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "Add description:"
        return label
    }()

    lazy var textField: UITextField = {
        let frame = CGRect(origin: CGPoint(x:  16, y: label.frame.maxY + 8),
                           size: CGSize(width: view.frame.size.width - 32, height: 32))
        let field = UITextField(frame: frame)
        field.contentMode = .scaleAspectFit
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 5
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(textField)
        setupShareButton()
    }

    private func setupShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Share",
            style: .plain,
            target: self,
            action: #selector(shareTapped))
    }
    
    @objc func shareTapped() {
        guard let img = image else { return }
        loagingProvider.start()
        DataProviders.shared.postsDataProvider.newPost(with: img, description: textField.text ?? "", queue: QProvider.gueue()) { post in 
            DispatchQueue.main.async { [weak self] in
                loagingProvider.stop()
                guard let _ = post else {
                    self?.showLoadingError()
                    return
                }
                guard let delegate = self?.navigationController?.viewControllers[0] as? DescriptionViewDeledate else { return }
                delegate.photoShared()
            }
        }
    }
}
