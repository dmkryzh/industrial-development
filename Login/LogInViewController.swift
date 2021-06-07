//
//  LogInViewController.swift
//  Navigation
//
//  Created by Дмитрий on 16.01.2021.
//

import UIKit
import SnapKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {
    
    var viewModel: LoginViewModel
    
    weak var coordinator: LoginCoordinator?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    let login: UITextField = {
        let login = UITextField()
        login.textColor = .black
        login.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        login.autocapitalizationType = .none
        login.tintColor = UIColor.init(named: "accentColor")
        login.layer.borderWidth = 0.5
        login.addInternalPaddings(left: 10, right: 10)
        login.autocapitalizationType = .none
        login.addTarget(self, action: #selector (isFilled), for: .editingChanged)
        login.placeholder = "Email or phone"
        return login
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .black
        return indicator
    }()
    
    lazy var password: UITextField = {
        let password = UITextField()
        password.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        password.autocapitalizationType = .none
        password.tintColor = UIColor(named: "accentColor")
        password.textColor = .black
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none
        password.addInternalPaddings(left: 10, right: 40)
        password.placeholder = "Password"
        password.rightView?.addSubview(activityIndicator)
        password.addTarget(self, action: #selector (isFilled), for: .editingChanged)
        let rightView = password.rightView?.frame.size ?? CGSize.zero
        activityIndicator.center = CGPoint(x: rightView.width / 2, y: rightView.height / 2)
        return password
    }()
    
    let logo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.clipsToBounds = true
        logo.backgroundColor = .white
        return logo
    }()
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(1), for: .normal)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(0.8), for: .selected)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(0.8), for: .highlighted)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(0.4), for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .selected)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.isEnabled = false
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector (signInLogic), for: .touchUpInside)
        return button
    }()
    
    let hackPassword: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подобрать пароль", for: .normal)
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
        button.addTarget(self, action: #selector (brut), for: .touchUpInside)
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(1), for: .normal)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(0.8), for: .selected)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(0.8), for: .highlighted)
        button.setBackgroundImage(UIImage(named: "blue_pixel")?.alpha(0.8), for: .disabled)
        button.addTarget(self, action: #selector (registerUser), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .selected)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var stackLogPas: UIStackView = {
        let stackLogPas = UIStackView(arrangedSubviews: [login, password])
        stackLogPas.alignment = .fill
        stackLogPas.distribution = .fillEqually
        stackLogPas.axis = .vertical
        stackLogPas.spacing = 10
        stackLogPas.layer.cornerRadius = 10
        stackLogPas.layer.borderWidth = 0.5
        stackLogPas.layer.masksToBounds = true
        stackLogPas.backgroundColor = .systemGray6
        stackLogPas.spacing = 0
        return stackLogPas
    }()
    
    lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "Registration", message: "Please fill email and password", preferredStyle: .alert)
        alert.addTextField() { login in
            login.textColor = .black
            login.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            login.autocapitalizationType = .none
            login.tintColor = UIColor.init(named: "accentColor")
            login.addInternalPaddings(left: 10, right: 10)
            login.autocapitalizationType = .none
            login.placeholder = "Email or phone"
            login.addTarget(self, action: #selector(self.isFilledRegistrationFields), for: .editingChanged)
        }
        
        alert.addTextField() { password in
            password.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            password.autocapitalizationType = .none
            password.tintColor = UIColor(named: "accentColor")
            password.textColor = .black
            password.isSecureTextEntry = true
            password.autocapitalizationType = .none
            password.addInternalPaddings(left: 10, right: 40)
            password.placeholder = "Password"
            password.addTarget(self, action: #selector(self.isFilledRegistrationFields), for: .editingChanged)
        }
        
        let actionOk = UIAlertAction(title: "OK", style: .default) { [self] _ in
            guard let _ = alert.textFields?[0].text else { return }
            viewModel.createUser(email: alert.textFields![0].text!, password: alert.textFields![1].text!){
                let alertCreated = UIAlertController(title: "Created", message: "Account is successefully created", preferredStyle: .alert)
                present(alertCreated, animated: true) {
                    dismiss(animated: true, completion: nil)
                    sleep(3)
                }
            }
            
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default)
        actionOk.isEnabled = false
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        
        return alert
    }()
    
    // MARK: Constraints
    
    func setupConstraints() {
        scrollView.snp.makeConstraints() { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints() { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(view.safeAreaLayoutGuide)
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
        
        hackPassword.snp.makeConstraints() { make in
            make.top.equalTo(logInButton.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.trailing.equalTo(containerView.snp.trailing).inset(16)
        }
        
        registerButton.snp.makeConstraints() { make in
            make.top.equalTo(hackPassword.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.trailing.equalTo(containerView.snp.trailing).inset(16)
            make.bottom.equalTo(containerView.snp.bottom)
        }
    }
    
    // MARK: Functions
    
    @objc func brut() {
        viewModel.brut(indicator: activityIndicator) { [weak self] value in
            guard let self = self else { return }
            self.password.text = value
            self.password.isSecureTextEntry = false
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc func isFilled() {
        viewModel.didEnterText(login: self.login.text, password: self.password.text, trueCompletion: {
            self.logInButton.isEnabled = true
        }, falseCompletion: {
            self.logInButton.isEnabled = false
        })
    }
    
    @objc func isFilledRegistrationFields() {
        viewModel.didEnterText(login: alert.textFields?[0].text, password: alert.textFields?[1].text, trueCompletion: {
            self.alert.actions[0].isEnabled = true
        }, falseCompletion: {
            self.alert.actions[0].isEnabled = false
        })
    }
    
    @objc func navigateTo() {
        guard let coordinator = coordinator else { return }
        viewModel.navigateTo(login: self.login.text, password: self.password.text, trueCompletion: {
            coordinator.startProfile()
        },
        falseCompletion: {
            let alert = UIAlertController(title: "Error", message: "Wrong login or\\and password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            coordinator.navController.present(alert, animated: true, completion: nil)
        })
        
    }
    
    lazy var successAlert = UIAlertController(title: "Success", message: "Account is created", preferredStyle: .alert)
    
    var failureAlert = UIAlertController(title: "Failure", message: "Either login or passworg is wrong, please try again", preferredStyle: .alert)
    
    @objc func signInLogic() {
        guard let coordinator = coordinator else { return }
        viewModel.signIn(email: login.text ?? "", password: password.text ?? "",
                                         signInCompletion: {
                                            coordinator.startProfile()
                                         },
                                         alertCompletion: { [self] in
                                            viewModel.showLoginAlert(email: login.text ?? "", password: password.text ?? "", alertHandler: { alert in
                                                                    present(alert, animated: true, completion: nil)},
                                                    successHandler: {
                                                        present(successAlert, animated: true) {
                                                            sleep(1)
                                                            dismiss(animated: true)
                                                        }
                                                    },
                                                    failureHandler: nil)
                                         } )
    }
    
    
    @objc func registerUser() {
        guard let coordinator = coordinator else { return }
        coordinator.navController.present(alert, animated: true, completion: nil)
    }
    
    init(_ viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(scrollView)
        scrollView.addSubviews(containerView)
        containerView.addSubviews(logo, stackLogPas, logInButton, hackPassword, registerButton)
        setupConstraints()
        print("пароль: \(LoginChecker.shared.password)")
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
