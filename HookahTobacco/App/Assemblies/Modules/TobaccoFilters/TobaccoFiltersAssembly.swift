//
//
//  TobaccoFiltersAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 29.08.2023.
//
//

import Foundation
import Swinject

struct TobaccoFiltersDependency {
    var appRouter: AppRouterProtocol
    var filters: TobaccoFilters?
    var delegate: TobaccoFiltersOutputModule?
}

class TobaccoFiltersAssembly: Assembly {
    func assemble(container: Container) {

        container.register(TobaccoFiltersRouterProtocol.self) { (_, dependency: TobaccoFiltersDependency) in
            let router = TobaccoFiltersRouter(dependency.appRouter)
            router.delegate = dependency.delegate
            return router
        }

        container.register(
            TobaccoFiltersInteractorInputProtocol.self
        ) { (resolver, dependency: TobaccoFiltersDependency) in
            // here resolve dependency injection
            let dataNetworkingService = resolver.resolve(GetDataNetworkingServiceProtocol.self)!

            return TobaccoFiltersInteractor(filters: dependency.filters,
                                            dataNetworkingService: dataNetworkingService)
        }

        container.register(TobaccoFiltersViewOutputProtocol.self) { _ in
            let presenter = TobaccoFiltersPresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(TobaccoFiltersViewController.self) { (resolver, dependency: TobaccoFiltersDependency) in
            let view = TobaccoFiltersViewController()
            let presenter = resolver.resolve(TobaccoFiltersViewOutputProtocol.self) as! TobaccoFiltersPresenter
            let interactor = resolver.resolve(
                TobaccoFiltersInteractorInputProtocol.self,
                argument: dependency
            ) as! TobaccoFiltersInteractor
            let router = resolver.resolve(TobaccoFiltersRouterProtocol.self, argument: dependency)!

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
