//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Дмитрий on 19.01.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var post: Post? {
        didSet {
            titleLabel.text = post?.title
            imagePost.image = UIImage(named: (post?.imageName ?? "default"))
            likesLabel.text = ("Likes: \(post?.likes ?? "")")
            viewsLabel.text = ("Views: \(post?.views ?? "")")
            descriptionLabel.text = post?.description
        }
    }
    
    var savedPost: PostStorage? {
        didSet {
            titleLabel.text = savedPost?.title
            imagePost.image = UIImage(named: (savedPost?.image ?? "default"))
            likesLabel.text = ("Likes: \(savedPost!.likes)")
            viewsLabel.text = ("Views: \(savedPost!.views)")
            descriptionLabel.text = savedPost?.postDescription
        }
    }
    
    var onSaveLikedPostTap: (() -> Void)?
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = .black
        title.numberOfLines = 2
        title.toAutoLayout()
        return title
    }()
    
    lazy var gesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(likeTap))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()
    
    lazy var likesLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        likesLabel.textColor = .black
        likesLabel.toAutoLayout()
        likesLabel.isUserInteractionEnabled = true
        likesLabel.addGestureRecognizer(gesture)
        return likesLabel
    }()
    
    let viewsLabel: UILabel = {
        let viewsLabel = UILabel()
        viewsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        viewsLabel.textColor = .black
        viewsLabel.toAutoLayout()
        return viewsLabel
    }()
    
    let heart: UIImageView = {
        let image = UIImage(systemName: "heart.fill")
        let heart = UIImageView(image: image)
        heart.alpha = 0
        heart.toAutoLayout()
        return heart
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .systemGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.toAutoLayout()
        return descriptionLabel
    }()
    
    lazy var imagePost: UIImageView = {
        let imagePost = UIImageView()
        imagePost.toAutoLayout()
        imagePost.backgroundColor = .black
        imagePost.contentMode = .scaleAspectFit
        return imagePost
    }()
   
    @objc func likeTap() {
        guard let onSaveLikedPostTap = onSaveLikedPostTap else { return }
        onSaveLikedPostTap()
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.heart.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.heart.alpha = 0
            }
        })
    }
    
    func setupConstraints() {
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 48),
            
            imagePost.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            imagePost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagePost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagePost.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: imagePost.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            heart.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            heart.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor),
            heart.centerXAnchor.constraint(equalTo: likesLabel.centerXAnchor),
            heart.widthAnchor.constraint(equalToConstant: 40),
            heart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(titleLabel, imagePost, descriptionLabel, likesLabel, heart, viewsLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
