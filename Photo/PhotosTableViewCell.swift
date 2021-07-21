//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Дмитрий on 24.01.2021.
//

import UIKit
import SnapKit

class PhotosTableViewCell: UITableViewCell {
    
    var photosHighlights = PhotosHighlightsView()
    
    private func setupConstraints() {
        photosHighlights.snp.makeConstraints() { make in
            make.top.leading.bottom.trailing.equalTo(contentView).inset(12)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(photosHighlights)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
    
