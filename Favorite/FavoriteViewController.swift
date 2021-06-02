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
    
    @objc func showFilterAlert() {
        let alert = UIAlertController(title: "Enter an author name", message: nil, preferredStyle: .alert)
        let handler = {
            self.viewModel.predicate = alert.textFields?[0].text
            self.viewModel.reloadOutput?.reloadData()
        }
        let action = UIAlertAction(title: "Apply", style: .default, handler: { _ in
            handler()
        })
        
        alert.addTextField { text in
            text.placeholder = "Author"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func removeFilter() {
            self.viewModel.predicate = nil
            self.viewModel.reloadOutput?.reloadData()
    }
    
    
    func createNavBarItems() {
        let remove = UIBarButtonItem(title: "Delete all", style: .plain, target: self, action: #selector (resetTable))
        navigationItem.rightBarButtonItem = remove
        let removeSorting = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector (removeFilter))
        let addSorting = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector (showFilterAlert))
        navigationItem.leftBarButtonItems = [addSorting, removeSorting]
        
    }
    
    @objc func resetTable() {
        viewModel.removeAll()
    }
    
    init(vm: FavoriteVM) {
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
        vm.reloadOutput = self
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
        viewModel.fetchPosts()
    }
}

extension FavoriteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.viewModel.savePosts?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellFromPost: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
        cellFromPost.savedPost = self.viewModel.savePosts?[indexPath.item]
        return cellFromPost
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.reloadOutput?.reloadData()
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, success) in
            guard let post = viewModel.savePosts else { return }
            viewModel.deletePost(post[indexPath.item])
            success(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension FavoriteViewController: FavoriteVmOutput {
    func reloadData() {
        self.viewModel.fetchPosts()
        tableView.reloadData()
    }
}
