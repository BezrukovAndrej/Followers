//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 04.05.2024.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

final class UserInfoVC: UIViewController {
    
    private  var username: String = ""
    private let padding: CGFloat = 20
    private let itemHeight: CGFloat = 140
    private let headerView = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()
    private let dateLabel = GFBodyLabel(textAlignment: .center)
    weak var delegate: UserInfoVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstraints()
        configureViewController()
        getUserInfo()
    }
    
    @objc
    private func dismassVC() {
        dismiss(animated: true)
    }
    
    func set(username: String) {
        self.username = username
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(dismassVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: Constants.AlertText.wrongMessage,
                                                message: error.rawValue.localized,
                                                buttonTitle: Constants.ButtonName.actionButtonOk)
            }
        }
    }
    
    private func configureUIElements(with user: User) {
        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self
        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text = Constants.UserInfo.creationDate + (user.createdAt?.convertToMonthYearFormat() ?? "")
    }
}

// MARK: - UserInfoVCDelegate

extension UserInfoVC: ItemInfoVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: Constants.AlertText.invalidURL,
                                       message: Constants.AlertText.invalidUserURL,
                                       buttonTitle: Constants.ButtonName.actionButtonOk)
            return
        }
        
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: Constants.AlertText.noFollowers,
                                       message: Constants.AlertText.userNoFollowers,
                                       buttonTitle: Constants.ButtonName.soSad)
            return
        }
        delegate?.didRequestFollowers(for: user.login)
        dismassVC()
    }
}

// MARK: - Add subviews / Set constraints

extension UserInfoVC {
    
    private func addSubviews() {
        [headerView, itemViewOne, itemViewTwo, dateLabel].forEach {
            view.addViewWithNoTAMIC($0)
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
}
