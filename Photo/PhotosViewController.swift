//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Дмитрий on 24.01.2021.
//

import UIKit
import SnapKit

class PhotosViewController: UIViewController {
    
    weak var coordinator: ProfileCoordinator?
    
    var viewModel: PhotosViewModel
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: viewModel.collectionIdentifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(viewModel: PhotosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func useTimer() {
        viewModel.toUpdatekWithTimeInterval(timeInterval: 1.0) {
            self.viewModel.timerString(propagateTo: &self.timerLabel.text)
        }
        
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints() { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        timerLabel.snp.makeConstraints() { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(30)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Gallery"
        view.backgroundColor = .white
        view.addSubviews(collectionView, timerLabel)
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        useTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        useTimer()
        
    }
}
