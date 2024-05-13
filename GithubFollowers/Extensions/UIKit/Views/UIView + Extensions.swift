//
//  UIView + Extensions.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 28.04.2024.
//

import UIKit

extension UIView {
    func addViewWithNoTAMIC(_ views: UIView) {
        self.addSubview(views)
        views.translatesAutoresizingMaskIntoConstraints = false
    }
}
