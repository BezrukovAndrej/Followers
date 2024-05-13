//
//  GFFollowerItemVC.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 05.05.2024.
//

import UIKit

final class GFFollowerItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user?.followers ?? 0)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user?.following ?? 0)
        actionButton.set(backgroundColor: .systemGreen, title: Constants.UserInfo.getFollowers)
    }
    
    override func actionButtonTapped() {
        if let user  {
            delegate?.didTapGetFollowers(for: user)
        }
    }
}
