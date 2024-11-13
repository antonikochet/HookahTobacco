//
//  ProfileRouter.swift
//  HookahTobaccoAdmin
//
//  Created by Антон Кочетков on 05.07.2024.
//

import UIKit

protocol ProfileRouterProtocol: RouterProtocol {
    func showLoginView()
    func showFavoriteList()
    func showWantToBuyList()
    func showCreateAppeal()
    func showAdminMenu()
}

final class ProfileRouter: ProfileRouterProtocol {
    var appRouter: AppRouterProtocol

    init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showLoginView() {
        appRouter.presentView(module: LoginModule.self, moduleData: nil, animated: true)
    }

    func showFavoriteList() {
    }

    func showWantToBuyList() {
    }

    func showCreateAppeal() {
    }
    
    func showAdminMenu() {
        appRouter.presentView(module: AdminMenuModule.self, moduleData: nil, animated: true)
    }
}
