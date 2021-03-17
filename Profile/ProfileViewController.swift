//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Дмитрий on 21.12.2020.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    var someState = false
    
    var center: CGPoint?
    
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
        cross.tintColor = .white
        cross.isUserInteractionEnabled = true
        return cross
    }()
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.toAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .lightGray
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: String(describing: PhotosTableViewCell.self))
        return tableView
    }()
    
    lazy var ava: UIImageView = {
        let avaView = UIImageView()
        avaView.layer.cornerRadius = 50
        avaView.clipsToBounds = true
        avaView.layer.borderWidth = 3
        avaView.image = UIImage(named: "1ava")
        avaView.contentMode = .scaleAspectFill
        avaView.layer.borderColor = UIColor.white.cgColor
        avaView.isUserInteractionEnabled = true
        avaView.alpha = 0
        return avaView
    }()
    
    lazy var avaGesture = UITapGestureRecognizer(target: self, action: #selector(avaTap))
    
    
    //MARK: Обработка нажатия
    
    @objc func avaTap() {
        print("tap")
        self.someState.toggle()
        
        let animationIn = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            
            if self.someState == true {
                
                self.ava.alpha = 1
                self.header.avaView.alpha = 0
                self.tableView.alpha = 0.5
                self.cross.alpha = 1
                self.viewWillLayoutSubviews()
            }
            
            else {
                self.ava.alpha = 0
                self.header.avaView.alpha = 1
                self.tableView.alpha = 1
                self.cross.alpha = 0
                self.viewWillLayoutSubviews()
                self.header.avaView.isHidden = false
            }
            
        }
        
        animationIn.startAnimation()
        
    }
    
//    lazy var constraints = [
//        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//
//    ]
    
    func setupConstraints() {
        tableView.snp.makeConstraints() { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubviews(tableView, ava, cross)
        self.cross.addGestureRecognizer(avaGesture)
        setupConstraints()
        //NSLayoutConstraint.activate(constraints)
        center = self.ava.center
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // если вью было нажато
        if someState {
            self.cross.frame = CGRect(x: self.ava.frame.maxX - 45, y: self.ava.frame.minY + 15, width: 30, height: 30)
            // проверка, чтобы правильно отобразить аватарку при изменении ротации
            if self.view.frame.height > self.view.frame.width {
                
                self.ava.frame.size = CGSize(width: self.view.safeAreaLayoutGuide.layoutFrame.width, height: self.view.safeAreaLayoutGuide.layoutFrame.width)
                self.ava.center = self.view.center
                self.ava.layer.cornerRadius = 0
                
            } else {
                
                self.ava.frame.size = CGSize(width: self.view.safeAreaLayoutGuide.layoutFrame.height , height: self.view.safeAreaLayoutGuide.layoutFrame.height)
                self.ava.center = CGPoint(x: self.view.safeAreaLayoutGuide.layoutFrame.midX, y: self.view.safeAreaLayoutGuide.layoutFrame.midY)
                self.ava.layer.cornerRadius = 0
            }
            
        } else {
            
            self.ava.frame = CGRect(x:  self.view.safeAreaInsets.left + 16, y: self.view.safeAreaInsets.top + 16, width: 100, height: 100)
            self.cross.frame = CGRect(x: self.ava.frame.maxX - 45, y: self.ava.frame.minY + 15, width: .zero, height: .zero)
            self.ava.layer.cornerRadius = 50
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
        switch section {
        case 1:
            return 16
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .lightGray
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        let photosViewController = PhotosViewController()
        photosViewController.title = "Photo Gallery"
        navigationController?.pushViewController(photosViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
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
            return cellFromPhoto
        case 1:
            let cellFromPost: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
            cellFromPost.post = PostItems.tableStruct[indexPath.row]
            return cellFromPost
        default:
            return UITableViewCell(frame: .zero)
        }
    }
    
}
