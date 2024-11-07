//
//
//  AppealsListAssembly.swift
//  HookahTobaccoAdmin
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import Foundation
import Swinject
import HookahTobaccoCore
import HookahTobaccoCoreAdmin

struct AppealsListDependency {
    var appRouter: AppRouterProtocol
}

class AppealsListAssembly: Assembly {
    func assemble(container: Container) {

        container.register(AppealsListRouterProtocol.self) { (_, dependency: AppealsListDependency) in
            let router = AppealsListRouter(dependency.appRouter)
            return router
        }

        container.register(AppealsListInteractorInputProtocol.self) { resolver in
            // here resolve dependency injection
            let appealsRepo = resolver.resolve(AppealsRepoProtocol.self)!
            let adminAppealsRepo = resolver.resolve(AdminAppealsRepoProtocol.self)!
            return AppealsListInteractor(appealsRepo: appealsRepo,
                                         adminAppealsRepo: adminAppealsRepo)
        }

        container.register(AppealsListViewOutputProtocol.self) { _ in
            let presenter = AppealsListPresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(AppealsListViewController.self) { (resolver, dependency: AppealsListDependency) in
            let view = AppealsListViewController()
            let presenter = resolver.resolve(AppealsListViewOutputProtocol.self) as! AppealsListPresenter
            let interactor = resolver.resolve(AppealsListInteractorInputProtocol.self) as! AppealsListInteractor
            let router = resolver.resolve(AppealsListRouterProtocol.self, argument: dependency)!

            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter

            presenter.router = router
            return view
        }
        // swiftlint:enable force_cast
    }
}
