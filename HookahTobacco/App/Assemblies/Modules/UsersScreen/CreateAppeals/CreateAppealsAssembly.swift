//
//
//  CreateAppealsAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//
//

import Foundation
import Swinject

struct CreateAppealsDependency {
    var appRouter: AppRouterProtocol
}

class CreateAppealsAssembly: Assembly {
    func assemble(container: Container) {

        container.register(CreateAppealsRouterProtocol.self) { (_, dependency: CreateAppealsDependency) in
            let router = CreateAppealsRouter(dependency.appRouter)
            return router
        }

        container.register(CreateAppealsInteractorInputProtocol.self) { resolver in
            // here resolve dependency injection
            let appealsNetworkingService = resolver.resolve(AppealsNetworkingServiceProtocol.self)!
            return CreateAppealsInteractor(appealsNetworkingService: appealsNetworkingService)
        }

        container.register(CreateAppealsViewOutputProtocol.self) { _ in
            let presenter = CreateAppealsPresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(CreateAppealsViewController.self) { (resolver, dependency: CreateAppealsDependency) in
            let view = CreateAppealsViewController()
            let presenter = resolver.resolve(CreateAppealsViewOutputProtocol.self) as! CreateAppealsPresenter
            let interactor = resolver.resolve(CreateAppealsInteractorInputProtocol.self) as! CreateAppealsInteractor
            let router = resolver.resolve(CreateAppealsRouterProtocol.self, argument: dependency)!

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
