//
//  GFRepoItemVC.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 05.05.2024.
//

import UIKit

final class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user?.publicRepos ?? 0)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user?.publicGists ?? 0)
        actionButton.set(backgroundColor: .systemPurple, title: Constants.UserInfo.gitProfile)
    }
    
    override func actionButtonTapped() {
        if let user {
            delegate?.didTapGitHubProfile(for: user)
        }
    }
}
