//
//  ViewController.swift
//  Navigation
//

import UIKit
import SnapKit

protocol FeedViewOutput {
    func showPost(_:Post)
    func showPlayer()
    var navigationController: UINavigationController? { get set }
}

class FeedViewController: UIViewController {
    
    weak var coordinator: FeedCoordinator?
    
    var output: FeedViewOutput?
    
    lazy var containerView: UIView = {
        let container = ContainerView()
        container.onTap = output?.showPost(_:)
        container.testOnTap = output?.showPlayer
        return container
    }()
    
    func setupConstraints() {
        containerView.snp.makeConstraints() { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        output = PostPresenter()
        output?.navigationController = navigationController
        view.addSubview(containerView)
        setupConstraints()
        print(type(of: self), #function)
        
    }
    
}

//MARK: ContainerView

class ContainerView: UIView {
    
    let post: Post = Post(title: "Пост", author: nil, description: nil, imageName: nil, likes: nil, views: nil)
    
    var onTap: ((Post) -> Void)?
    
    var testOnTap: (() -> Void)?
    
    let newButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("button1", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(navigationTo), for: .touchUpInside)
        return button
    }()
    
    let secondNewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("button2", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(navigationTo), for: .touchUpInside)
        return button
    }()
    
    let thirdNewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("music", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(navigationToPlayer), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        buttonsStack.addArrangedSubview(newButton)
        buttonsStack.addArrangedSubview(secondNewButton)
        buttonsStack.addArrangedSubview(thirdNewButton)
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fillEqually
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 0
        buttonsStack.layer.cornerRadius = 10
        buttonsStack.layer.masksToBounds = true
        return buttonsStack
    }()
    
    func newConstraints() {
        buttonsStack.snp.makeConstraints() { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func navigationTo() {
        guard onTap != nil else { return }
        onTap!(post)
    }
    
    @objc private func navigationToPlayer() {
        guard testOnTap != nil else { return }
        testOnTap!()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(buttonsStack)
        newConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: PostPresenter
class PostPresenter: FeedViewOutput {
    
    func showPost(_ post: Post) {
        let postViewController = PostViewController()
        postViewController.post = post
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    func showPlayer() {
        let playerView = MusicViewController()
        navigationController?.pushViewController(playerView, animated: true)
    }
    
    var navigationController: UINavigationController?
    
}

