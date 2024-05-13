//
//  GFItemInfoView.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 05.05.2024.
//

import UIKit

enum ItemInfoType {
    case repos, gists, followers, following
}

final class GFItemInfoView: UIView {
    
    private let symbolImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.tintColor = .label
        return image
    }()
    
    private let titleLabel = GFTitleLabel(textAlignment: .left, size: 14)
    private let countLabel = GFTitleLabel(textAlignment: .center, size: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image = Constants.repos
            titleLabel.text = Constants.UserInfo.repos
        case .gists:
            symbolImageView.image = Constants.gists
            titleLabel.text = Constants.UserInfo.gists
        case .followers:
            symbolImageView.image = Constants.followers
            titleLabel.text = Constants.UserInfo.followers
        case .following:
            symbolImageView.image = Constants.following
            titleLabel.text = Constants.UserInfo.following
        }
        countLabel.text = String(count)
    }
}

// MARK: - Add subviews / Set constraints

extension  GFItemInfoView{
    
    private func addSubviews() {
        [symbolImageView, titleLabel, countLabel].forEach { addViewWithNoTAMIC($0) }
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
