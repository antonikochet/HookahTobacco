//
//
//  ProfileRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 04.01.2023.
//
//

import UIKit

protocol ProfileRouterProtocol: RouterProtocol {
    func showLoginView()
    func showFavoriteList()
    func showWantToBuyList()
    func showCreateAppeal()
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
        let data = TobaccoListDataModile(filter: .favorite)
        appRouter.pushViewController(module: TobaccoListModule.self, moduleData: data, animateDisplay: true)
    }

    func showWantToBuyList() {
        let data = TobaccoListDataModile(filter: .wantBuy)
        appRouter.pushViewController(module: TobaccoListModule.self, moduleData: data, animateDisplay: true)
    }

    func showCreateAppeal() {
        appRouter.pushViewController(module: CreateAppealsModule.self, moduleData: nil, animateDisplay: true)
    }
}
