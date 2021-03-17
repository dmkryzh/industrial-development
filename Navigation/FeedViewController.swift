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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let postViewController = storyboard.instantiateViewController(identifier: "PostViewController") as? PostViewController else { return }
        postViewController.post = post
        show(postViewController, sender: nil)
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
    
//    func addStack() {
//        buttonStackView.addArrangedSubview(newButton)
//        buttonStackView.addArrangedSubview(secondNewButton)
//        buttonStackView.alignment = .fill
//        buttonStackView.distribution = .fillEqually
//        buttonStackView.axis = .vertical
//        buttonStackView.spacing = 10
//        buttonStackView.layer.cornerRadius = 10
//        buttonStackView.layer.masksToBounds = true
//        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
//        buttonStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//        buttonStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
//        buttonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print(type(of: self), #function)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(type(of: self), #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
