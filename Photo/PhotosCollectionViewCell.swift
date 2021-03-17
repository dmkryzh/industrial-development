//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Дмитрий on 24.01.2021.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    var imageItem: Photo? {
        didSet {
            photo.image = UIImage(named: imageItem?.imageName ?? "")
        }
    }
    
    let photo: UIImageView = {
        let photo = UIImageView()
        photo.image = nil
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.toAutoLayout()
        return photo
    }()
    
    func setupConstraints() {
        photo.snp.makeConstraints() { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photo)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
