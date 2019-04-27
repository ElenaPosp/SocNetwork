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
    func openPrifile(withID id: User.Identifier)
}

class UsersListViewController: UIViewController {

    let cellIdentifier = String(describing: UITableViewCell.self)
    var users: [User] = []
    var profileDelegate: ProfileNavigationViewController?
    var delegate: UsersListDelegare?

    lazy var usersTableView: UITableView = {
        let table = UITableView(frame: self.view.frame)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(usersTableView)
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}

extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        delegate?.openPrifile(withID: users[indexPath.row].id)
    }
}

extension UsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = usersTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        newCell.textLabel?.text = users[indexPath.row].fullName
        newCell.imageView?.image = users[indexPath.row].avatar
        return newCell
    }
}
