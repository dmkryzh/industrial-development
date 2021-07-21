//
//  PhotosHighlightsView.swift
//  Navigation
//
//  Created by Дмитрий on 24.01.2021.
//

import UIKit
import SnapKit

class PhotosHighlightsView: UIView {
    
    private let title: UILabel = {
        let title = UILabel()
        title.text = StringsForLocale.profilePhotos.localaized
        title.textColor = .label
        title.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return title
    }()
    
    private let arrow: UIImageView = {
        let arrowConfig = UIImage.SymbolConfiguration(textStyle: .title3)
        let arrow = UIImageView()
        arrow.tintColor = .label
        arrow.image = UIImage(systemName: "arrow.forward", withConfiguration: arrowConfig)
        return arrow
    }()
    
    private lazy var viewStack: UIStackView = {
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
        return viewStack
    }()
    
    private func setupConstraints() {
        
        title.snp.makeConstraints() { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
        }
        
        arrow.snp.makeConstraints() { make in
            make.centerY.equalTo(title.snp.centerY)
            make.trailing.equalTo(self.snp.trailing)
        }
        
        viewStack.snp.makeConstraints() { make in
            make.height.lessThanOrEqualTo(self.snp.width).multipliedBy(0.25).inset((8 * 3 + 12 * 2) / 4)
            make.top.equalTo(title.snp.bottom).offset(12)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(title, arrow, viewStack)
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
