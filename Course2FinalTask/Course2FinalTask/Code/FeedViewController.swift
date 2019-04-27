//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 13/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedViewController: UIViewController  {

    var navDelegate: FeedCellDelegate?
    
    let posts = DataProviders.shared.postsDataProvider.feed()
    let cellIdentifier = String(describing: FeedTableViewCell.self)
    
    let dateFormatter: DateFormatter = {
        let a = DateFormatter()
        a.dateFormat = "MMM dd, yyyy hh:mm:ss a"
        return a
    }()
    
    lazy var feedTableView: UITableView = {
        let table = UITableView(frame: self.view.frame)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        feedTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
//        setupNavigationBar()
    }

    func setupNavigationBar() {
        navigationItem.title = "Feed"
    }
    
    private func setupTableView() {
        view.addSubview(feedTableView)
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        feedTableView.deselectRow(at: indexPath, animated: false)
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = feedTableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                     for: indexPath) as! FeedTableViewCell
        cell.authorAvatarImageView.image = post.authorAvatar
        cell.authorNameLabel.text = post.authorUsername
        cell.postImageView.image = post.image
        cell.postTimeLabel.text = dateFormatter.string(from: post.createdTime)
        cell.postDescriptionLabel.text = post.description
        cell.likeImageView.tintColor = .lightGray
        cell.delegate = navDelegate
        cell.postID = post.id
        return cell
    }
}
