//
//
//  DetailAppealAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.09.2023.
//
//

import Foundation
import Swinject

struct DetailAppealDependency {
    var appRouter: AppRouterProtocol
    var appeal: AppealResponse
}

class DetailAppealAssembly: Assembly {
    func assemble(container: Container) {

        container.register(DetailAppealRouterProtocol.self) { (_, dependency: DetailAppealDependency) in
            let router = DetailAppealRouter(dependency.appRouter)
            return router
        }

        container.register(DetailAppealInteractorInputProtocol.self) { (resolver, dependency: DetailAppealDependency) in
            // here resolve dependency injection
            let adminNetworkingService = resolver.resolve(AdminNetworkingServiceProtocol.self)!
            let dataNetworingService = resolver.resolve(GetDataNetworkingServiceProtocol.self)!
            return DetailAppealInteractor(appeal: dependency.appeal,
                                          adminNetworkingService: adminNetworkingService,
                                          dataNetworingService: dataNetworingService)
        }

        container.register(DetailAppealViewOutputProtocol.self) { _ in
            let presenter = DetailAppealPresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(DetailAppealViewController.self) { (resolver, dependency: DetailAppealDependency) in
            let view = DetailAppealViewController()
            let presenter = resolver.resolve(DetailAppealViewOutputProtocol.self) as! DetailAppealPresenter
            let interactor = resolver.resolve(
                DetailAppealInteractorInputProtocol.self,
                argument: dependency
            ) as! DetailAppealInteractor
            let router = resolver.resolve(DetailAppealRouterProtocol.self, argument: dependency)!

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
