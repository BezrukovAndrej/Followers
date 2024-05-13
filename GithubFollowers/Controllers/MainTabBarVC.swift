//
//  MainTabBarVC.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 28.04.2024.
//

import UIKit

final class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        viewControllers = generateViewControllers()
        generateTabBarIconsWithName(for: viewControllers)
    }
    
    private func generateViewControllers() -> [UIViewController] {
        let searchVC = UINavigationController(rootViewController: SearchVC())
        let favoriteListVC = UINavigationController(rootViewController: FavoriteListVC())
        UINavigationBar.appearance().tintColor = .systemGreen
        return [searchVC, favoriteListVC]
    }
    
    private func generateTabBarIconsWithName(for viewControllers: [UIViewController]?) {
        guard let viewControllers else { return }
        
        let searchImage = UIImage.IconMainBar.searchImage
        let favoriteListImage = UIImage.IconMainBar.favoriteImage
        let imagesArray = [searchImage, favoriteListImage]
        
        let searchName = Constants.ButtonName.search
        let favoriteName = Constants.ButtonName.favorite
        let nameArray = [searchName, favoriteName]
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        lineView.backgroundColor = .systemGreen
        tabBar.insertSubview(lineView, at: 0)
        tabBar.tintColor = .systemGreen
        
        for (index, viewController) in viewControllers.enumerated() {
            viewController.tabBarItem.image = imagesArray[index]
            viewController.tabBarItem.title = nameArray[index]
        }
    }
}
