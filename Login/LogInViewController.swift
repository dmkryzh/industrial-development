//
//  LogInViewController.swift
//  Navigation
//
//  Created by Дмитрий on 16.01.2021.
//

import UIKit
import SnapKit

protocol LogInViewControllerDelegate: class {
    func validateLogin(_: String) -> Bool
    func validatePassword(_: String) -> Bool
}

class LogInViewController: UIViewController {
    
    var delegate: LogInViewControllerDelegate?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.toAutoLayout()
        return scrollView
    }()
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.toAutoLayout()
        return containerView
    }()
    
    let login: UITextField = {
        let login = UITextField()
        login.textColor = .black
        //login.toAutoLayout()
        login.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        login.autocapitalizationType = .none
        login.tintColor = UIColor.init(named: "accentColor")
        login.layer.borderWidth = 0.5
        login.addInternalPaddings(left: 10, right: 10)
        login.autocapitalizationType = .none
        login.placeholder = "Email or phone"
        return login
    }()
    
    let password: UITextField = {
        let password = UITextField()
        password.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        password.autocapitalizationType = .none
        password.tintColor = UIColor(named: "accentColor")
        password.textColor = .black
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none
        //password.toAutoLayout()
        password.addInternalPaddings(left: 10, right: 10)
        password.placeholder = "Password"
        return password
    }()
    
    let logo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.clipsToBounds = true
        logo.backgroundColor = .white
        logo.toAutoLayout()
        return logo
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(1), for: .normal)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(0.8), for: .selected)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(0.8), for: .highlighted)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(0.8), for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .selected)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector (navigateTo), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    lazy var stackLogPas: UIStackView = {
        let stackLogPas = UIStackView()
        stackLogPas.addArrangedSubview(login)
        stackLogPas.addArrangedSubview(password)
        stackLogPas.alignment = .fill
        stackLogPas.distribution = .fillEqually
        stackLogPas.axis = .vertical
        stackLogPas.spacing = 10
        stackLogPas.layer.cornerRadius = 10
        stackLogPas.layer.borderWidth = 0.5
        stackLogPas.layer.masksToBounds = true
        stackLogPas.backgroundColor = .systemGray6
        stackLogPas.spacing = 0
        stackLogPas.toAutoLayout()
        return stackLogPas
    }()
    
    // MARK: Constraints
    
    func setupConstraints() {
        scrollView.snp.makeConstraints() { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        containerView.snp.makeConstraints() { make in
            make.top.leading.bottom.trailing.centerX.centerY.equalToSuperview()
        }
        
        logo.snp.makeConstraints() { make in
            make.top.equalTo(containerView.snp.top).offset(120)
            make.height.width.equalTo(100)
            make.centerX.equalTo(containerView.snp.centerX)
        }
        
        stackLogPas.snp.makeConstraints() { make in
            make.top.equalTo(logo.snp.bottom).offset(120)
            make.height.equalTo(100)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.trailing.equalTo(containerView.snp.trailing).inset(16)
        }
        
        logInButton.snp.makeConstraints() { make in
            make.top.equalTo(stackLogPas.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.trailing.equalTo(containerView.snp.trailing).inset(16)
        }
    }
    
    //MARK: Functions
    
    @objc func navigateTo() {
        if loginCheck() {
            let profileViewController = ProfileViewController()
            show(profileViewController, sender: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Wrong login or\\and password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func loginCheck() -> Bool {
        guard delegate != nil else { return false}
        guard delegate!.validateLogin(self.login.text ?? "") &&
                delegate!.validatePassword(self.password.text ?? "") else { return true }
        return false
    }
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(scrollView)
        scrollView.addSubviews(containerView)
        containerView.addSubviews(logo, stackLogPas, logInButton)
        setupConstraints()
        delegate = LoginValidator()
    }
    
    // MARK: Keyboard observers
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard actions
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

// MARK: Extensions

extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}

extension UITextField {
    func addInternalPaddings(left: CGFloat, right: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: left, height: self.frame.height))
        self.rightView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: right, height: self.frame.height))
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
}

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

class LoginValidator: LogInViewControllerDelegate {
    
    func validateLogin(_ login: String) -> Bool {
        guard login == Checker.shared.login else { return true}
        return false
    }
    
    func validatePassword(_ password: String) -> Bool {
        guard password == Checker.shared.password else { return true}
        return false
    }
}

class Checker {
    static let shared = Checker()
    let login = "777"
    let password = "qwerty"
    private init() {}
}
