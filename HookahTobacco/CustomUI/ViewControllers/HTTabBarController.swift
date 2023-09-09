//
//  HTTabBarController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.10.2022.
//

import UIKit

struct TabBarItemContent: TabBarItemProtocol {
    var title: String
    var image: UIImage?
    var selectedImage: UIImage?
}

class HTTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
    }

    private func setupTabBarAppearance() {
        tabBar.tintColor = R.color.selecttabbar()
        tabBar.unselectedItemTintColor = R.color.secondarySubtitle()
        tabBar.backgroundColor = R.color.barsBackground()
        tabBar.backgroundImage = UIImage()

        tabBar.isTranslucent = true
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 32.0
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
