//
//  ViewController.swift
//  Navigation
//

import UIKit

final class FeedViewController: UIViewController {
    
    var previous = NSDecimalNumber.one
    var current = NSDecimalNumber.one
    var position: UInt = 1
    var updateTimer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    
    
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
    
    let thirdNewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("button3", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        return button
    }()
    
    let resultsLabel: UILabel = {
        let resultLabel = UILabel()
        resultLabel.backgroundColor = .white
        return resultLabel
    }()
    
    @objc private func navigationTo() {
        let postViewController = PostViewController()
        postViewController.view.backgroundColor = UIColor.systemOrange
        postViewController.post = post
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    lazy var buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        buttonsStack.addArrangedSubview(newButton)
        buttonsStack.addArrangedSubview(secondNewButton)
        buttonsStack.addArrangedSubview(thirdNewButton)
        buttonsStack.addArrangedSubview(resultsLabel)
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
    
    //MARK: Background Logic
    
    @objc private func didTapPlayPause() {
        thirdNewButton.isSelected = !thirdNewButton.isSelected
        if thirdNewButton.isSelected {
            resetCalculation()
            updateTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                                               selector: #selector(calculateNextNumber), userInfo: nil, repeats: true)
            // register background task
            registerBackgroundTask()
        } else {
            updateTimer?.invalidate()
            updateTimer = nil
            // end background task
            if backgroundTask != .invalid {
                endBackgroundTask()
            }
        }
    }
    
    @objc func calculateNextNumber() {
        let result = current.adding(previous)
        
        let bigNumber = NSDecimalNumber(mantissa: 1, exponent: 40, isNegative: false)
        if result.compare(bigNumber) == .orderedAscending {
            previous = current
            current = result
            position += 1
        } else {
            // This is just too much.... Start over.
            resetCalculation()
        }
        
        let resultsMessage = "Position \(position) = \(current)"
        switch UIApplication.shared.applicationState {
        case .active:
            resultsLabel.text = resultsMessage
        case .background:
            print("App is backgrounded. Next number = \(resultsMessage)")
            print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
        case .inactive:
            break
        @unknown default:
            fatalError()
        }
        
    }
    
    func resetCalculation() {
        previous = .one
        current = .one
        position = 1
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    @objc func reinstateBackgroundTask() {
        if updateTimer != nil && backgroundTask == .invalid {
            registerBackgroundTask()
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed"
        self.view.backgroundColor = .systemGreen
        print(type(of: self), #function)
        view.addSubview(buttonsStack)
        NSLayoutConstraint.activate(constraints)
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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




