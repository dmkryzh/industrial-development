//
//  PhotosHighlightsView.swift
//  Navigation
//
//  Created by Дмитрий on 24.01.2021.
//

import UIKit

class PhotosHighlightsView: UIView {
    
    let title: UILabel = {
        let title = UILabel()
        title.text = "Photos"
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        title.toAutoLayout()
        return title
    }()
    
    let arrow: UIImageView = {
        //let arrowConfig = UIImage.SymbolConfiguration(textStyle: .title3)
        let arrow = UIImageView()
        arrow.toAutoLayout()
        arrow.tintColor = .black
        //arrow.image = UIImage(systemName: "arrow.forward", withConfiguration: arrowConfig)
        return arrow
    }()
    
    lazy var viewStack: UIStackView = {
        let viewStack = UIStackView()
        for i in 0...3 {
            let imageView = UIImageView()
            imageView.layer.cornerRadius = 6
            imageView.image = UIImage(named: PhotoSet.photoSet[i].imageName ?? "")
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            viewStack.addArrangedSubview(imageView)
        }
        viewStack.alignment = .fill
        viewStack.distribution = .fillEqually
        viewStack.contentMode = .scaleAspectFill
        viewStack.axis = .horizontal
        viewStack.spacing = 8
        viewStack.toAutoLayout()
        return viewStack
    }()
    
    lazy var newConstraints = [
        
        title.topAnchor.constraint(equalTo: self.topAnchor),
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        
        arrow.centerYAnchor.constraint(equalTo: title.centerYAnchor),
        arrow.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        
        viewStack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
        viewStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        viewStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        viewStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        viewStack.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25, constant: -(8 * 3 + 12 * 2) / 4)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(title, arrow, viewStack)
        NSLayoutConstraint.activate(newConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
