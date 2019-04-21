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

    let collectionCellIdentifier = String(describing: ProfileCollectionViewCell.self)
    let firstCellIdentifier = String(describing: ProfileFirstCell.self)

    var profile: User?
    var posts: [Post] = []

    var navDelegate: ProfileViewControllerDelegate?

    lazy var profileCollectionView: UICollectionView = {
        let a = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        return a
    }()

    let userProfile = DataProviders.shared.usersDataProvider.currentUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    private func setupCollectionView() {
        if let id = profile?.id {
            posts = DataProviders.shared.postsDataProvider.findPosts(by: id) ?? []
        }

        view.addSubview(profileCollectionView)
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.backgroundColor = .white

        let nib1 = UINib(nibName: collectionCellIdentifier, bundle: nil)
        profileCollectionView.register(nib1, forCellWithReuseIdentifier: collectionCellIdentifier)

        let nib2 = UINib(nibName: firstCellIdentifier, bundle: nil)
        profileCollectionView.register(nib2, forCellWithReuseIdentifier: firstCellIdentifier)
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
        
        guard profile != nil else {
            return UICollectionViewCell()
        }

        if indexPath.row == 0 {
            
            let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: firstCellIdentifier, for: indexPath as IndexPath) as! ProfileFirstCell
            firstCell.avatarImageView.image = profile!.avatar
            firstCell.avatarImageView.layer.cornerRadius = firstCell.avatarImageView.frame.width/2
            firstCell.userNameLabel.text = profile!.fullName
            firstCell.followersLabel.text = "Followers: \(profile!.followedByCount)"
            firstCell.followingLabel.text = "Following: \(profile!.followsCount)"
            firstCell.navDelegate = navDelegate
            firstCell.userID = profile?.id
            return firstCell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath as IndexPath) as! ProfileCollectionViewCell
        cell.image.image = posts[indexPath.row-1].image
        return cell
    }
}
