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

    private let collectionCellIdentifier = String(describing: ProfileCollectionViewCell.self)
    private let firstCellIdentifier = String(describing: ProfileFirstCell.self)

    var profile: User? {
        didSet {
            setupCollectionView()
        }
    }
    var posts: [Post] = []

    var delegate: ProfileFirstCellDelegate?

    lazy var profileCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        loagingProvider.start()
        super.viewDidLoad()
        setupNavigationBar()
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

        

        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.backgroundColor = .white

        let cell = UINib(nibName: collectionCellIdentifier, bundle: nil)
        profileCollectionView.register(cell, forCellWithReuseIdentifier: collectionCellIdentifier)

        let firstCell = UINib(nibName: firstCellIdentifier, bundle: nil)
        profileCollectionView.register(firstCell, forCellWithReuseIdentifier: firstCellIdentifier)
        
        guard let id = profile?.id else { return }
            
        DataProviders.shared.postsDataProvider.findPosts(by: id, queue: QProvider.gueue()) {[weak self] in
            guard let strSelf = self else { return }
            guard let postArr = $0 else {
                strSelf.posts = []
                strSelf.showLoadingError()
                return
            }
            strSelf.posts = postArr

            DispatchQueue.main.async {
                strSelf.view.addSubview(strSelf.profileCollectionView)
            }
        }
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

        guard let profile = profile else { return UICollectionViewCell() }

        if indexPath.row == 0 {
            loagingProvider.stop()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firstCellIdentifier,
                                                          for: indexPath as IndexPath) as! ProfileFirstCell
            cell.user = profile
            cell.avatarImageView.image = profile.avatar
            cell.userNameLabel.text = profile.fullName
            cell.delegate = delegate
            cell.followersLabel.text = "Followers: \(profile.followedByCount)"
            cell.followingLabel.text = "Following: \(profile.followsCount)"
            return cell
        }

        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier,
                                                             for: indexPath as IndexPath) as! ProfileCollectionViewCell
        cell.image.image = posts[indexPath.row-1].image
        return cell
    }
}
