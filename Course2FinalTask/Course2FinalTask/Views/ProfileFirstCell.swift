//
//  ProfileFirstCell.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 15/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


protocol ProfileFirstCellDelegate {
    
    func didTapFollowers(userID id: User.Identifier)
    func didTapFollowing(userID id: User.Identifier)
}

class ProfileFirstCell: UICollectionViewCell {
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var delegate: ProfileFirstCellDelegate?
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
        guard let id = userID else { return }
        delegate?.didTapFollowers(userID: id)
    }
    
    @objc func didTapFollowing() {
        guard let id = userID else { return }
        delegate?.didTapFollowing(userID: id)
    }
}
