//
//  PersistenceManager.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 05.05.2024.
//

import Foundation

enum PersistenceActionType {
    case add , remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = Constants.key
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                var retrievedFaforites = favorites
                switch actionType {
                case .add:
                    guard !retrievedFaforites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    retrievedFaforites.append(favorite)
                case .remove:
                    retrievedFaforites.removeAll { $0.login == favorite.login }
                }
                completed(save(favorites: retrievedFaforites))
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Follower]) -> GFError? {
        
        do {
            let encoder = JSONEncoder()
            let encoderFavorites = try encoder.encode(favorites)
            defaults.set(encoderFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
