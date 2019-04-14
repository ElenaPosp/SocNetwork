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
    var profile = DataProviders.shared.usersDataProvider.currentUser()
    lazy var posts: [Post] = {
        DataProviders.shared.postsDataProvider.findPosts(by: profile.id) ?? []
    }()
    var navDelegate: ProfileViewControllerDelegate?
    
    lazy var profileCollectionView: UICollectionView = {
        let a = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        return a
    }()
    
    let userProfile = DataProviders.shared.usersDataProvider.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileCollectionView)
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        let nib = UINib(nibName: collectionCellIdentifier, bundle: nil)
        profileCollectionView.register(nib, forCellWithReuseIdentifier: collectionCellIdentifier)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    
}

extension ProfileViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return section == 0 ? 1 : posts.count
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath as IndexPath) as! ProfileCollectionViewCell
        cell.image.image = posts[indexPath.row].image
        return cell
    }
    
    
}



protocol ProfileViewControllerDelegate {
    func didSelectFollowers()
    func didSelectFollowered()
}
