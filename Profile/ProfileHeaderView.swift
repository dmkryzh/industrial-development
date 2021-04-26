//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Дмитрий on 21.01.2021.
//

import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    
    var someState = false
    
    private var statusText = "Waiting for something"
    private var name = "Default Name"
    
    let avaContainer = UIView()
    
    lazy var avaView: UIImageView = {
        let avaView = UIImageView()
        avaView.layer.cornerRadius = 50
        avaView.clipsToBounds = true
        avaView.layer.borderWidth = 3
        avaView.image = UIImage(named: "1ava")
        avaView.contentMode = .scaleAspectFill
        avaView.layer.borderColor = UIColor.white.cgColor
        return avaView
    }()
    
    lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = statusText
        statusLabel.textColor = .gray
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return statusLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return nameLabel
    }()
    
    lazy var statusTextField: UITextField = {
        let statusTextField = UITextField()
        statusTextField.layer.cornerRadius = 12
        statusTextField.layer.borderWidth = 1
        statusTextField.layer.borderColor = UIColor.black.cgColor
        statusTextField.backgroundColor = .white
        statusTextField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        statusTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        statusTextField.addInternalPaddings(left: 10, right: 10)
        return statusTextField
    }()
    
    lazy var statusButton: UIButton = {
        let statusButton = UIButton(type: .system)
        statusButton.backgroundColor = .systemBlue
        statusButton.setTitle("Show status", for: .normal)
        statusButton.setTitleColor(.white, for: .normal)
        statusButton.layer.cornerRadius = 14
        statusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        statusButton.layer.shadowOpacity = 0.7
        statusButton.layer.shadowColor = UIColor.black.cgColor
        statusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return statusButton
    }()
    
    lazy var grayView: UIView = {
        let grayView = UIView(frame: UIScreen.main.bounds)
        grayView.alpha = 0
        grayView.backgroundColor = .lightGray
        return grayView
    }()

    //MARK: Constraints
    func setupConstraints() {
        
        avaContainer.snp.makeConstraints() { make in
            make.height.width.equalTo(100)
            make.top.equalTo(self.snp.top).offset(16)
            make.leading.equalTo(self.snp.leading).offset(16)
        }
        
        avaView.snp.makeConstraints() { make in
            make.height.width.equalTo(100)
            make.top.equalTo(self.snp.top).offset(16)
            make.leading.equalTo(self.snp.leading).offset(16)
        }
        
        nameLabel.snp.makeConstraints() { make in
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).offset(27)
            make.leading.equalTo(avaContainer.snp.trailing).offset(24)
            make.trailing.equalTo(self.snp.trailing).inset(16)
        }
        
        statusLabel.snp.makeConstraints() { make in
            make.height.equalTo(20)
            make.top.equalTo(nameLabel.snp.top).offset(27)
            make.leading.equalTo(avaContainer.snp.trailing).offset(24)
            make.trailing.equalTo(self.snp.trailing).inset(16)
        }
        
        statusTextField.snp.makeConstraints() { make in
            make.height.equalTo(40)
            make.top.equalTo(avaContainer.snp.bottom).inset(24)
            make.leading.equalTo(avaContainer.snp.trailing).offset(24)
            make.trailing.equalTo(self.snp.trailing).inset(16)
        }
        
        statusButton.snp.makeConstraints() { make in
            make.height.equalTo(50)
            make.top.equalTo(avaContainer.snp.bottom).offset(50)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.bottom.equalTo(self.snp.bottom).inset(16)
            make.trailing.equalTo(self.snp.trailing).inset(16)
        }
    }
    
    @objc private func statusTextChanged(_ text: UITextField) {
        statusText = text.text!
        print(statusText)
    }
    
    @objc private func buttonPressed() {
        statusLabel.text = statusText
        statusTextField.text = nil
        print("\(statusText)")
    }
   
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubviews(avaContainer, avaView, nameLabel, statusLabel, statusTextField, statusButton, grayView)
        setupConstraints()
    }
    
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        contentView.addSubviews(avaContainer, nameLabel, statusLabel, statusTextField, statusButton, secondaryView, avaView)
//        setupConstraints()
//
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


