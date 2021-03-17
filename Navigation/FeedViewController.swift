//
//  ViewController.swift
//  Navigation
//
//  Created by Artem Novichkov on 12.09.2020.
//  Copyright © 2020 Artem Novichkov. All rights reserved.
//

import UIKit

final class FeedViewController: UIViewController {
    
    let post: Post = Post(title: "Пост", author: nil, description: nil, imageName: nil, likes: nil, views: nil)
    
    let newButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("button1", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(navigationTo), for: .touchUpInside)
        return button
    }()
    
    let secondNewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("button2", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(navigationTo), for: .touchUpInside)
        return button
    }()
    
    @objc private func navigationTo() {
        let postViewController = PostViewController()
        postViewController.post = post
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    lazy var buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        buttonsStack.addArrangedSubview(newButton)
        buttonsStack.addArrangedSubview(secondNewButton)
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fillEqually
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 0
        buttonsStack.layer.cornerRadius = 10
        buttonsStack.layer.masksToBounds = true
        buttonsStack.toAutoLayout()
        return buttonsStack
    }()
    
    lazy var constraints = [
        buttonsStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
        buttonsStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        buttonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        print(type(of: self), #function)
        view.addSubview(buttonsStack)
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(type(of: self), #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(type(of: self), #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(type(of: self), #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(type(of: self), #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(type(of: self), #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(type(of: self), #function)
    }
}

