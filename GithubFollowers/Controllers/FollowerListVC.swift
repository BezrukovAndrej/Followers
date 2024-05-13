//
//  FollowerListVC.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 29.04.2024.
//

import UIKit

enum Section {
    case main
}

final class FollowerListVC: UIViewController {
    
    private var username: String = ""
    private var followers: [Follower] = []
    private var filterFollowers: [Follower] = []
    private var page = 1
    private var hasMoreFollowers = true
    private var isSearchig = false
    private var isLoadingMoreFollowers = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = UIHelper.createThreeColumnFlowLayout(in: view)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: Constants.identifierFollowerCell)
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = Constants.SearchBar.searchUser
        return searchController
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        view.addViewWithNoTAMIC(collectionView)
        collectionView.delegate = self
        configureViewController()
        getFollowers(userName: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func getFollowers(userName: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty {
                    let message = Constants.EmptyMessage.message
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    return 
                }
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: GFError.message.rawValue.localized,
                                                message: error.rawValue.localized,
                                                buttonTitle: Constants.ButtonName.actionButtonOk)
            }
            self.isLoadingMoreFollowers = false
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { ( collectionView, indexPath, follower) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.identifierFollowerCell, for: indexPath) as? FollowerCell else {
                return UICollectionViewCell()
            }
            cell.set(follower: follower)
            return cell
        })
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { [weak self] in
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc
    private func addButtonTapped() {
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite,
                                              actionType: .add) { [weak self] error in
                    guard let self else { return }
                    guard let error else {
                        self.presentGFAlertOnMainThread(title: Constants.AlertText.success,
                                                        message: Constants.AlertText.successFovorite,
                                                        buttonTitle: Constants.AlertText.hooray)
                        return
                    }
                    self.presentGFAlertOnMainThread(title: Constants.AlertText.wrongMessage,
                                                    message: error.rawValue.localized,
                                                    buttonTitle: Constants.ButtonName.actionButtonOk)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: Constants.AlertText.wrongMessage,
                                                message: error.rawValue.localized,
                                                buttonTitle: Constants.ButtonName.actionButtonOk)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(userName: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearchig ? filterFollowers : followers
        let follower  = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.set(username: follower.login)
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filterFollowers.removeAll()
            updateData(on: followers)
            isSearchig = false
            return
        }
        isSearchig = true
        filterFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filterFollowers)
    }
}

// MARK: - FollowerListDelegate

extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filterFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                    at: .top, animated: true)
        getFollowers(userName: username, page: page)
    }
}
