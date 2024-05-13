//
//  User.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 30.04.2024.
//

import Foundation

struct User: Decodable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date?
}
