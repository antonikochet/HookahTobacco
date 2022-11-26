//
//
//  AdminMenuAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//
//

import Foundation
import Swinject

struct AdminManuDependency {
    let appRouter: AppRouterProtocol
}

class AdminMenuAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AdminMenuRouterProtocol.self) { (_, dependency: AdminManuDependency) in
            let router = AdminMenuRouter(dependency.appRouter)
            return router
        }
        container.register(AdminMenuInteractorInputProtocol.self) { resolver in
            // here resolve dependency injection
            let getDataManager = resolver.resolve(GetDataNetworkingServiceProtocol.self)!
            let setDataManager = resolver.resolve(SetDataNetworkingServiceProtocol.self)!
            return AdminMenuInteractor(getDataManager: getDataManager,
                                       setDataManager: setDataManager)
        }
        container.register(AdminMenuViewOutputProtocol.self) { _ in
            let presenter = AdminMenuPresenter()
            return presenter
        }
        // swiftlint:disable force_cast
        container.register(AdminMenuViewController.self) { (resolver, dependency: AdminManuDependency) in
            let view = AdminMenuViewController()
            let presenter = resolver.resolve(AdminMenuViewOutputProtocol.self) as! AdminMenuPresenter
            let interactor = resolver.resolve(AdminMenuInteractorInputProtocol.self) as! AdminMenuInteractor
            let router = resolver.resolve(AdminMenuRouterProtocol.self, argument: dependency)!

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
