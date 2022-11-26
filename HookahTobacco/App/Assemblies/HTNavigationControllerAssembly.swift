//
//  HTNavigationControllerAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.10.2022.
//

import UIKit
import Swinject

protocol TabBarItemProtocol {
    var title: String { get }
    var image: UIImage? { get }
    var selectedImage: UIImage? { get }
}

struct HTNavigationControllerDependency {
    let appRouter: AppRouterProtocol
    let module: ModuleProtocol
    let tabBarItem: TabBarItemProtocol
}

class HTNavigationControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(
            HTNavigationController.self
        ) { (_, dependency: HTNavigationControllerDependency) in

            let rootVC = dependency.module.createModule(dependency.appRouter)!

            let navContoller = HTNavigationController(rootViewController: rootVC)
            navContoller.setupTabBarItem(with: dependency.tabBarItem.title,
                                         image: dependency.tabBarItem.image,
                                         selectedImage: dependency.tabBarItem.selectedImage)
            return navContoller
        }
        .inObjectScope(.transient)
    }
}
