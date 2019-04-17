//
//  FeedTableViewCell.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 14/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    
    var delegate:FeedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInteractive()
    }
    
    func setupInteractive() {
        
        authorAvatarImageView.isUserInteractionEnabled = true
        let g1 = UITapGestureRecognizer(target: self, action: #selector(didSelectAuthorAvatar))
        authorAvatarImageView.addGestureRecognizer(g1)
        
        likesLabel.isUserInteractionEnabled = true
        let g2 = UITapGestureRecognizer(target: self, action: #selector(didSelectAuthorAvatar))
        likesLabel.addGestureRecognizer(g2)
        
        likeImageView.isUserInteractionEnabled = true
        let g3 = UITapGestureRecognizer(target: self, action: #selector(didSelectAuthorAvatar))
        likeImageView.addGestureRecognizer(g3)
        
        postImageView.isUserInteractionEnabled = true
        let g4 = UITapGestureRecognizer(target: self, action: #selector(didSelectAuthorAvatar))
        g4.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(g4)
    }
    
    @objc func didSelectAuthorAvatar(){
        print("AVATAR")
        delegate?.didTapAuthorAvatar(withID: "1")
    }
}


protocol FeedCellDelegate {
    func didTapAuthorAvatar(withID: String)
    func didLikePhoto()
    func didTapLikesCount()

}
