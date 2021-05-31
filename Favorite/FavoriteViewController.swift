//
//  FavoriteViewController.swift
//  Navigation
//
//  Created by Dmitrii KRY on 26.05.2021.
//

import Foundation
import UIKit
import SnapKit
import CoreData

class FavoriteViewController: UIViewController {
    
    var viewModel: FavoriteVM
    
    weak var coordinator: FavoriteCoordrinator?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.toAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .lightGray
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        return tableView
    }()
    
    func setupConstraints() {
        tableView.snp.makeConstraints() { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    func createNavBarItems() {
        let remove = UIBarButtonItem(title: "Delete all", style: .plain, target: self, action: #selector (resetTable))
        navigationItem.rightBarButtonItem = remove
    }
    
    @objc func resetTable() {
        viewModel.removeAll()
    }
    
    init(vm: FavoriteVM) {
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
        vm.reload = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(tableView)
        view.backgroundColor = .lightGray
        setupConstraints()
        createNavBarItems()
    }
}

extension FavoriteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.fetchPosts()
        guard let _ = viewModel.savePosts else { return 0 }
        return self.viewModel.savePosts!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.viewModel.fetchPosts()
        let cellFromPost: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
        cellFromPost.savedPost = self.viewModel.savePosts?[indexPath.item]
        return cellFromPost
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, success) in
            viewModel.deletePost((viewModel.savePosts?[indexPath.item])!)
            viewModel.fetchPosts()
            success(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension FavoriteViewController: FavoriteVmOutput {
    func reloadData() {
        tableView.reloadData()
    }
}
