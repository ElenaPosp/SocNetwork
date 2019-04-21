//
//  ProfileFirstCell.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 15/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


class ProfileFirstCell: UICollectionViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var navDelegate: ProfileFirstCellDelegate?
    var userID: User.Identifier?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInteractive()
    }

    func setupInteractive() {
        
        followersLabel.isUserInteractionEnabled = true
        let g1 = UITapGestureRecognizer(target: self, action: #selector(didTapFollowers))
        followersLabel.addGestureRecognizer(g1)
        
        followingLabel.isUserInteractionEnabled = true
        let g2 = UITapGestureRecognizer(target: self, action: #selector(didTapFollowing))
        followingLabel.addGestureRecognizer(g2)
    }
    
    @objc func didTapFollowers() {
        guard userID != nil else { return }
        navDelegate?.didTapFollowers(userID: userID!)
    }
    
    @objc func didTapFollowing() {
        guard userID != nil else { return }
        navDelegate?.didTapFollowing(userID: userID!)
    }
}
