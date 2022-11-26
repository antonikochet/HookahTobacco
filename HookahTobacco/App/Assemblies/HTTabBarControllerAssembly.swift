//
//  HTTabBarControllerAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.10.2022.
//

import Foundation
import Swinject

struct HTTabBarControllerDependency {
    typealias ItemContainer = (module: ModuleProtocol, tabBarItem: TabBarItemProtocol)
    let appRouter: AppRouterProtocol
    let containers: [ItemContainer]
}

class HTTabBarControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HTTabBarController.self) { (r, dependency: HTTabBarControllerDependency) in
            let tabBar = HTTabBarController()

            let containers = dependency.containers.map { item -> HTNavigationController in
                let dependency = HTNavigationControllerDependency(appRouter: dependency.appRouter,
                                                                  module: item.module,
                                                                  tabBarItem: item.tabBarItem)
                let container = r.resolve(HTNavigationController.self, argument: dependency)!
                return container
            }
            tabBar.viewControllers = containers
            return tabBar
        }
    }
}
