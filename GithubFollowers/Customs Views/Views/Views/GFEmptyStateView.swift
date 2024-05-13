//
//  GFEmptyStateView.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 04.05.2024.
//

import UIKit

final class GFEmptyStateView: UIView {
    
    private let messageLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .center, size: 28)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = Constants.emptyImageView
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
}

// MARK: - Add subviews / Set constraints

extension GFEmptyStateView {
    
    private func addSubviews() {
        [messageLabel, logoImageView].forEach{ addViewWithNoTAMIC($0) }
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 40)
        ])
    }
}
