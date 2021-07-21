//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Дмитрий on 21.12.2020.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    weak var coordinator: ProfileCoordinator?
    var viewModel: ProfileViewModel
    
    var someState = true
    
    lazy var header: ProfileHeaderView = {
        let header = ProfileHeaderView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(avaTap))
        header.avaView.isUserInteractionEnabled = true
        header.avaView.addGestureRecognizer(gesture)
        return header
    }()
    
    
    
    lazy var cross: UIImageView = {
        let cross = UIImageView()
        let crossConfig = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        cross.image = UIImage(systemName: "xmark", withConfiguration: crossConfig)
        cross.alpha = 0
        cross.tintColor = .label
        cross.isUserInteractionEnabled = true
        let crossGesture = UITapGestureRecognizer(target: self, action: #selector(crossTap))
        cross.addGestureRecognizer(crossGesture)
        return cross
    }()
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.toAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: String(describing: PhotosTableViewCell.self))
        return tableView
    }()
    
    //MARK: Анимация - start
    
    var avaPostition = UIView()
    var grayBackground = UIView()
    
    func animateCross(_ state: Bool, _ completion: ((Bool)->Void)? = nil) {
        if state {
            UIView.animate(withDuration: 0.3, animations: {
                self.cross.alpha = 1
                self.view.bringSubviewToFront(self.cross)
            },
            completion: completion)
            
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.cross.alpha = 0
            },
            completion: completion)
        }
    }
    
    @objc func avaTap() {
        
        guard someState else { return }
        
        avaPostition = self.header.avaView
        grayBackground = self.header.grayView
        
        func animateAvaToCenterProfile() {
            
            grayBackground.alpha = 0.5
            
            avaPostition.layer.cornerRadius = 0
            
            avaPostition.snp.remakeConstraints() { make in
                make.center.equalTo(self.view.safeAreaLayoutGuide.snp.center)
                
                if self.view.bounds.height > self.view.bounds.width {
                    make.width.height.equalTo(self.view.safeAreaLayoutGuide.snp.width)
                } else {
                    make.width.height.equalTo(self.view.safeAreaLayoutGuide.snp.height)
                }
            }
            
            self.view.layoutIfNeeded()
            self.view.addSubviews(grayBackground, avaPostition)
        }
        
        UIView.animate(withDuration: 0.5, animations: animateAvaToCenterProfile) {
            if $0 {
                self.animateCross(true)
            }
        }
        
        someState.toggle()
    }
    
    
    @objc func crossTap() {
        
        guard someState == false else { return }
        
        func animateAvaToInitialSize() {
            
            avaPostition.layer.cornerRadius = 50
            grayBackground.alpha = 0
            
            avaPostition.snp.remakeConstraints() { make in
                make.height.width.equalTo(100)
                make.center.equalTo(self.header.avaContainer.snp.center)
            }
            
            self.view.layoutIfNeeded()
            self.header.addSubviews(grayBackground, avaPostition)
        }
        
        animateCross(false) {
            if $0 {
                UIView.animate(withDuration: 0.5, animations: animateAvaToInitialSize) {
                    if $0 {
                        self.avaPostition.snp.remakeConstraints() { make in
                            make.height.width.equalTo(100)
                            make.center.equalTo(self.header.avaContainer.snp.center)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
        someState.toggle()
    }
    
    func didRotationChange() {
        avaPostition.snp.remakeConstraints() { make in
            make.center.equalTo(self.view.safeAreaLayoutGuide.snp.center)
            if self.view.bounds.height > self.view.bounds.width {
                make.width.height.equalTo(self.view.safeAreaLayoutGuide.snp.width)
            } else {
                make.width.height.equalTo(self.view.safeAreaLayoutGuide.snp.height)
            }
        }
        
        grayBackground.snp.remakeConstraints() { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    
    //MARK: Constraints
    
    func setupConstraints() {
        tableView.snp.makeConstraints() { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        cross.snp.makeConstraints() { make in
            make.top.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.width.equalTo(60)
        }
    }
    
    //MARK: LifeCycle
    
    init(vm:ProfileViewModel) {
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        view.addSubviews(tableView, cross)
        setupConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !someState {
            didRotationChange()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

// MARK: UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .systemBackground
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        coordinator?.startPhotos()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return UIView(frame: .zero) }
        return self.header
    }
}

// MARK: UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return PostItems.tableStruct.count
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cellFromPhoto: PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotosTableViewCell.self), for: indexPath) as! PhotosTableViewCell
            cellFromPhoto.selectionStyle = .none
            return cellFromPhoto
        case 1:
            let cellFromPost: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
            cellFromPost.post = PostItems.tableStruct[indexPath.row]
            cellFromPost.likesLabel.isUserInteractionEnabled = true
            cellFromPost.selectionStyle = .none
            cellFromPost.onSaveLikedPostTap = { [weak self] in
                self?.viewModel.saveLikedPost(PostItems.tableStruct[indexPath.row])
            }
            return cellFromPost
        default:
            return UITableViewCell(frame: .zero)
        }
    }
}
