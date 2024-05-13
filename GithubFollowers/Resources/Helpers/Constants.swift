//
//  Constants.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 30.04.2024.
//

import UIKit

struct Constants {
    static let identifierFollowerCell = "FollowerCell"
    static let identifierFavoriteCell = "FavoriteCell"
    static let key = "favorites"
    
    static let baseUrl = "https://api.github.com/users/"
    static let endPoint = "/followers?per_page=100&page="
    
    static let location = UIImage(systemName: "mappin.and.ellipse")
    static let repos = UIImage(systemName: "folder")
    static let gists = UIImage(systemName: "text.alignleft")
    static let followers = UIImage(systemName: "person.2")
    static let following = UIImage(systemName: "heart")
    static let emptyImageView = UIImage(named: "empty-state-logo")
    static let avatarPlaceHolder = "avatar-placeholder"
    
    enum ButtonName {
        static let search = "SEARCH".localized
        static let favorite = "FAVORITE".localized
        static let placeholder = "ENTER_NAME".localized
        static let actionButton = "GET_FOLLOWERS".localized
        static let actionButtonOk = "OK".localized
        static let soSad = "SO_SAD".localized
    }
    
    enum AlertText {
        static let emptyUser = "EMPTY".localized
        static let message = "MESSAGE".localized
        static let wrongMessage = "WRONG".localized
        static let unableMessage = "UNABLE".localized
        static let unableRemove = "UNABLE_REMOVE".localized
        static let invalidURL = "INVALID_URL".localized
        static let invalidUserURL = "URL_USER_INVALID".localized
        static let noFollowers = "NO_FOLLOWERS".localized
        static let userNoFollowers = "THIS_USER_NO_FOOLOWERS".localized
        static let success = "SUCCESS".localized
        static let successFovorite = "SUCCESSFULLY_FOVORITED".localized
        static let hooray = "HOORAY".localized
    }
    
    enum EmptyMessage {
        static let message = "EMPTY_MESSAGE".localized
        static let noFavorites = "NO_FAVORITES".localized
    }
    
    enum SearchBar {
        static let searchUser = "SEARCH_USER".localized
        static let favorite = "FAVORITE".localized
    }
    
    enum UserInfoHeader {
        static let noLocation = "NO_LOCATION".localized
        static let bio =  "NO_BIO".localized
    }
    
    enum UserInfo {
        static let repos = "REPOS".localized
        static let gists = "GISTS".localized
        static let followers = "FOLLOWERS".localized
        static let following = "FOLLOWING".localized
        static let getFollowers = "GET_FOLLOWERS".localized
        static let gitProfile = "GIT_PROFILE".localized
        static let creationDate = "CREATION_DATE".localized
    }
    
    enum ScreenSize {
        static let widht = UIScreen.main.bounds.size.width
        static let height = UIScreen.main.bounds.size.height
        static let maxLenght = max(ScreenSize.widht, ScreenSize.height)
        static let minLenght = min(ScreenSize.widht, ScreenSize.height)
    }
    
    enum DeviceType {
        static let idiom = UIDevice.current.userInterfaceIdiom
        static let nativeScale = UIScreen.main.nativeScale
        static let scale = UIScreen.main.scale
        
        static let isiPhoneSE = idiom == .phone && ScreenSize.maxLenght == 568.0
        static let isiPhone8Standard = idiom == .phone && ScreenSize.maxLenght == 667.0 && nativeScale == scale
        static let isiPhone8Zoomed = idiom == .phone && ScreenSize.maxLenght == 667.0 && nativeScale > scale
        static let isiPhone8PlusStandart = idiom == .phone && ScreenSize.maxLenght == 736.0
        static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLenght == 736.0 && nativeScale > scale
        static let isiPhoneX = idiom == .phone && ScreenSize.maxLenght == 812.0
        static let isiPhoneXMaxAndXr = idiom == .phone && ScreenSize.maxLenght == 896.0
        static let isiPad = idiom == .pad && ScreenSize.maxLenght >= 1024.0
        
        static func isPhoneXAspectRatio() -> Bool {
            return isiPhoneX || isiPhoneXMaxAndXr
        }
    }
}
