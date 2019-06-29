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

    var delegate: FeedCellDelegate?
    var currentUser: User?
    var posts: [Post] = []
    
    
    private let cellIdentifier = String(describing: FeedTableViewCell.self)
    
    lazy var dateFormatter: DateFormatter = {
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
        Loading.start()
        setupTableView()
        
        DataProviders.shared.postsDataProvider.feed(queue: QProvider.gueue()) { [weak self] (postArr) in
            self?.posts = postArr ?? []
            DispatchQueue.main.async {
//                sleep(5)
                self?.feedTableView.reloadData()
                Loading.stop()
            }
            
        }
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        feedTableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }

    private func setupTableView() {
        view.addSubview(feedTableView)
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }
    
    func setUpLoadingView() {
//        view.addSubview()
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

        cell.currentUser = currentUser
        cell.authorAvatarImageView.image = post.authorAvatar
        cell.authorNameLabel.text = post.authorUsername
        cell.postImageView.image = post.image
        cell.postTimeLabel.text = dateFormatter.string(from: post.createdTime)
        cell.postDescriptionLabel.text = post.description
        cell.likeImageView.tintColor = .lightGray
        cell.delegate = delegate
        cell.postID = post.id
        return cell
    }
}
