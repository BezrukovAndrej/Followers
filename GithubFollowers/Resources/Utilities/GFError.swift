//
//  GFError.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 30.04.2024.
//

import Foundation

enum GFError: String, Error {
    case invalidUserName = "INVALID_USER_NAME"
    case unableToComplete = "UNABLE_TO_COMPLETE"
    case invalidResponse = "INVALID_RESPONSE"
    case invalidData = "INVALID_DATA"
    case message = "SOMETHING_WENT_WRONG"
    case unableToFavorite = "UNABLE_TO_FAVORITES"
    case alreadyInFavorites = "ALREADY_IN_FAVORITES"
}
