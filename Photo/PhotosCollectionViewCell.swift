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
    
    lazy var newConstraints = [
        photo.topAnchor.constraint(equalTo: self.topAnchor),
        photo.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        photo.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        photo.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photo)
        NSLayoutConstraint.activate(newConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
