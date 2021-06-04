//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Дмитрий on 19.01.2021.
//

import UIKit
import SnapKit

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
        likesLabel.isUserInteractionEnabled = true
        likesLabel.addGestureRecognizer(gesture)
        return likesLabel
    }()
    
    let viewsLabel: UILabel = {
        let viewsLabel = UILabel()
        viewsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        viewsLabel.textColor = .black
        return viewsLabel
    }()
    
    let heart: UIImageView = {
        let image = UIImage(systemName: "heart.fill")
        let heart = UIImageView(image: image)
        heart.alpha = 0
        return heart
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .systemGray
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    lazy var imagePost: UIImageView = {
        let imagePost = UIImageView()
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
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.leading.trailing.equalToSuperview().offset(16)
        }
        
        imagePost.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.width)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16)
            make.top.equalTo(imagePost.snp.bottom).offset(16)
        }
        
        likesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
        }
        
        viewsLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
        }
        
        heart.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(8)
            make.width.equalTo(45)
            make.centerX.equalTo(likesLabel.snp.centerX)
        }
    }
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(titleLabel, imagePost, descriptionLabel, likesLabel, viewsLabel, heart)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
