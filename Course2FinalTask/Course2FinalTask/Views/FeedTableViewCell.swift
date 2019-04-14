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
        setupRecognizers()
    }
    
    func setupRecognizers() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(didSelectAuthorAvatar))
        gr.numberOfTapsRequired = 1
        authorAvatarImageView.addGestureRecognizer(gr)
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
