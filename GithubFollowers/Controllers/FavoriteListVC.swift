//
//  FavoriteListVC.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 28.04.2024.
//

import UIKit

final class FavoriteListVC: UIViewController {
    
    private let tableView = UITableView()
    private var favorites: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = Constants.SearchBar.favorite
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let favorites):
                if favorites.isEmpty {
                    showEmptyStateView(with: Constants.EmptyMessage.noFavorites, in: self.view)
                } else {
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: Constants.AlertText.wrongMessage,
                                                message: error.rawValue.localized,
                                                buttonTitle: Constants.ButtonName.actionButtonOk)
            }
        }
    }
    
    private func configureTableView() {
        view.addViewWithNoTAMIC(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
}

// MARK: - UITableViewDelegate

extension FavoriteListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListVC(username: favorite.login)
        navigationController?.pushViewController(destVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FavoriteListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as? FavoriteCell else {
            return UITableViewCell()
        }
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PersistenceManager.updateWith(favorite: favorite,
                                      actionType: .remove) { [weak self] error in
            guard let self else { return }
            guard let error else { return }
            self.presentGFAlertOnMainThread(title: Constants.AlertText.unableRemove,
                                            message: error.rawValue.localized,
                                            buttonTitle: Constants.ButtonName.actionButtonOk)
        }
    }
}
