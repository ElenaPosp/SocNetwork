//
//  FeedTableViewCell.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 14/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

protocol FeedCellDelegate {
    func didTapAuthorAvatar(withID ID: User.Identifier)
    func didLikePhoto()
    func didTapLikesCount(postID: Post.Identifier)
}

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    
    var postID: Post.Identifier?
    var delegate: FeedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInteractive()
    }
    
    func setupInteractive() {
        
        authorAvatarImageView.isUserInteractionEnabled = true
        let g1 = UITapGestureRecognizer(target: self, action: #selector(didSelectAuthorAvatar))
        authorAvatarImageView.addGestureRecognizer(g1)
        
        likesLabel.isUserInteractionEnabled = true
        let g2 = UITapGestureRecognizer(target: self, action: #selector(didTapLikesCount))
        likesLabel.addGestureRecognizer(g2)
        
        likeImageView.isUserInteractionEnabled = true
        let g3 = UITapGestureRecognizer(target: self, action: #selector(didTaplike))
        likeImageView.addGestureRecognizer(g3)
        
        postImageView.isUserInteractionEnabled = true
        let g4 = UITapGestureRecognizer(target: self, action: #selector(didTapBiglike))
        g4.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(g4)
    }
    
    @objc func didSelectAuthorAvatar(){
        guard
            postID != nil,
            let authtorID = DataProviders.shared.postsDataProvider.post(with: postID!)?.author
        else { return }
        delegate?.didTapAuthorAvatar(withID: authtorID)
    }

    @objc func didTaplike(){
        guard postID != nil else {
            return
        }
    }

    @objc func didTapBiglike(){
        guard postID != nil else {
            return
        }
    }
    
    @objc func didTapLikesCount() {
        guard postID != nil else {
            return
        }
        delegate?.didTapLikesCount(postID: postID!)
    }
    
    
}

