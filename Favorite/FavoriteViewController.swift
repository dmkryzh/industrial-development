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
    
    private var isDataLoaded = false
    
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
    
    private func setupConstraints() {
        tableView.snp.makeConstraints() { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func showFilterAlert() {
        let alert = UIAlertController(title: "Enter an author name", message: nil, preferredStyle: .alert)
        let handler = { [ weak self ] in
            guard let self = self else { return }
            self.viewModel.author = alert.textFields?[0].text
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
        self.viewModel.author = nil
    }
    
    
    private func createNavBarItems() {
        let remove = UIBarButtonItem(title: "Delete all", style: .plain, target: self, action: #selector (resetTable))
        navigationItem.rightBarButtonItem = remove
        let removeSorting = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector (removeFilter))
        let addSorting = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector (showFilterAlert))
        navigationItem.leftBarButtonItems = [addSorting, removeSorting]
    }
    
    @objc func resetTable() {
        guard let objectsArray = viewModel.fetchResultsController.fetchedObjects else { return }
        objectsArray.forEach { post in
            viewModel.deletePost(post)
        }
    }
    
    init(vm: FavoriteVM) {
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
        vm.reloadOutput = self
        vm.fetchResultsController.delegate = self
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !isDataLoaded {
            isDataLoaded = true
            viewModel.context.perform {
                do {
                    try self.viewModel.fetchResultsController.performFetch()
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
}

//MARK: Extentions

extension FavoriteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellFromPost: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
        cellFromPost.savedPost = viewModel.fetchResultsController.object(at: indexPath)
        return cellFromPost
    }
}


extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, success) in
            guard let self = self else { return }
            let post = self.viewModel.fetchResultsController.object(at: indexPath)
            self.viewModel.deletePost(post)
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

extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        tableView.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { fallthrough }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { fallthrough }
            
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .move:
            guard
                let indexPath = indexPath,
                let newIndexPath = newIndexPath
            else { fallthrough }
            
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { fallthrough }
            
            tableView.reloadRows(at: [indexPath], with: .fade)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        tableView.endUpdates()
    }
}
