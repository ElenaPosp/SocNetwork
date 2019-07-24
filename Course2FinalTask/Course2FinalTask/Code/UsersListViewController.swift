//
//  UsersListViewController.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 21/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

protocol UsersListDelegare {

    func openProfile(withID id: User.Identifier)
}

class UsersListViewController: UIViewController {

    let cellIdentifier = String(describing: UITableViewCell.self)
    var users: [User] = []
    var delegate: UsersListDelegare?
    private var selectedIndexPath: IndexPath?

    lazy var usersTableView: UITableView = {
        let table = UITableView(frame: self.view.frame)
        return table
    }()

    override func viewDidLoad() {
        loagingProvider.start()
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(usersTableView)
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let indexPath = selectedIndexPath else { return }
        usersTableView.deselectRow(at: indexPath, animated: false)
    }
}

extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loagingProvider.start()
        delegate?.openProfile(withID: users[indexPath.row].id)
        selectedIndexPath = indexPath
    }
}

extension UsersListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { loagingProvider.stop() }

        let newCell = usersTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        newCell.textLabel?.text = users[indexPath.row].fullName
        newCell.imageView?.image = users[indexPath.row].avatar
        return newCell
    }
}
