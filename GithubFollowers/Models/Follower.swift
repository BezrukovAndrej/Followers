//
//  Follower.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 30.04.2024.
//

import Foundation

struct Follower: Codable, Hashable {
    let login: String
    let avatarUrl: String
}
