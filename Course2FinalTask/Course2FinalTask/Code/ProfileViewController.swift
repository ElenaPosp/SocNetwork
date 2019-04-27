//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 13/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ProfileViewController: UIViewController {

    var isMain: Bool = false
    let collectionCellIdentifier = String(describing: ProfileCollectionViewCell.self)
    let firstCellIdentifier = String(describing: ProfileFirstCell.self)

    var profile: User?
    var posts: [Post] = []

    var delegate: ProfileFirstCellDelegate?

    lazy var profileCollectionView: UICollectionView = {
        return UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

        if !isMain {
            setupNavigationBar()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }

    private func setupCollectionView() {
        if let id = profile?.id {
            posts = DataProviders.shared.postsDataProvider.findPosts(by: id) ?? []
        }

        view.addSubview(profileCollectionView)
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.backgroundColor = .white

        let cell = UINib(nibName: collectionCellIdentifier, bundle: nil)
        profileCollectionView.register(cell, forCellWithReuseIdentifier: collectionCellIdentifier)

        let firstCell = UINib(nibName: firstCellIdentifier, bundle: nil)
        profileCollectionView.register(firstCell, forCellWithReuseIdentifier: firstCellIdentifier)
    }

    private func setupNavigationBar() {
        navigationItem.title = profile?.fullName
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        if indexPath.row == 0 {
            return CGSize(width: width, height: 86)
        }
        return CGSize(width: Int(width/3), height: Int(width/3))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ProfileViewController:UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let profile = profile else {
            return UICollectionViewCell()
        }

        if indexPath.row == 0 {

            let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: firstCellIdentifier,
                                                               for: indexPath as IndexPath) as! ProfileFirstCell
            firstCell.avatarImageView.image = profile.avatar
            firstCell.avatarImageView.layer.cornerRadius = firstCell.avatarImageView.frame.width/2
            firstCell.userNameLabel.text = profile.fullName
            firstCell.followersLabel.text = "Followers: \(profile.followedByCount)"
            firstCell.followingLabel.text = "Following: \(profile.followsCount)"
            firstCell.delegate = delegate
            firstCell.userID = profile.id
            return firstCell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier,
                                                      for: indexPath as IndexPath) as! ProfileCollectionViewCell
        cell.image.image = posts[indexPath.row-1].image
        return cell
    }
}
