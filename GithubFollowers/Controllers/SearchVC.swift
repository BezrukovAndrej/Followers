//
//  SearchVC.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 28.04.2024.
//

import UIKit

final class SearchVC: UIViewController {
    
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage.IconImage.logoImage
        return image
    }()
    
    private lazy var callActionButton: GFButton = {
        let button = GFButton(backgroundColor: .systemGreen,
                              title: Constants.ButtonName.actionButton)
        button.addTarget(self,
                         action: #selector(puschFollowerListVC),
                         for: .touchUpInside)
        return button
    }()
    
    private let userNameTextField = GFTextField()
    private var isUserNameEntered: Bool { return !userNameTextField.text!.isEmpty }
    private var logoImageViewTopConstraint: NSLayoutConstraint! // исправить !!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        setConstraints()
        createDismissKeyboardTapGesture()
        
        userNameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view,
                                         action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func puschFollowerListVC() {
        guard isUserNameEntered else {
            presentGFAlertOnMainThread(title: Constants.AlertText.emptyUser ,
                                       message: Constants.AlertText.message,
                                       buttonTitle: Constants.ButtonName.actionButtonOk)
            return }
        userNameTextField.resignFirstResponder()
        let followerListVC = FollowerListVC(username: userNameTextField.text ?? "")
        navigationController?.pushViewController(followerListVC, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        puschFollowerListVC()
        return true
    }
}

// MARK: - Add subviews / Set constraints

extension SearchVC {
    
    private func addSubviews() {
        [logoImageView,
         userNameTextField,
         callActionButton].forEach { view.addViewWithNoTAMIC($0)}
    }
    
    private func setConstraints() {
        let topConstraintConstant: CGFloat = Constants.DeviceType.isiPhoneSE || Constants.DeviceType.isiPhone8Zoomed ? 20 : 80
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        logoImageViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            callActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
