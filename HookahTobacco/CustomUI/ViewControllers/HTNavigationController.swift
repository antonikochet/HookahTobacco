//
//  HTNavigationController.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.10.2022.
//

import UIKit

class HTNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        setStatusBar(backgroundColor: R.color.barsBackground())
    }

    func setupTabBarItem(with title: String,
                         image: UIImage?,
                         selectedImage: UIImage?) {
        self.tabBarItem = UITabBarItem(title: title,
                                       image: image?.withRenderingMode(.alwaysTemplate),
                                       selectedImage: selectedImage?.withRenderingMode(.alwaysTemplate))
    }

    private func setupNavigationBar() {
        navigationBar.tintColor = R.color.secondarySubtitle()
        navigationBar.barTintColor = R.color.barsBackground()
        navigationBar.backgroundColor = R.color.barsBackground()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    private func setStatusBar(backgroundColor: UIColor?) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
}
