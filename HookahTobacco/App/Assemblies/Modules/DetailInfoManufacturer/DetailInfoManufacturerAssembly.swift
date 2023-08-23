//
//
//  DetailInfoManufacturerAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.11.2022.
//
//

import Foundation
import Swinject

struct DetailInfoManufacturerDependency {
    var appRouter: AppRouterProtocol
    var manufacturer: Manufacturer
}

class DetailInfoManufacturerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(
            DetailInfoManufacturerRouterProtocol.self
        ) { (_, dependency: DetailInfoManufacturerDependency) in
            let router = DetailInfoManufacturerRouter(dependency.appRouter)
            return router
        }

        container.register(DetailInfoManufacturerInteractorInputProtocol.self
        ) { (resolver, dependency: DetailInfoManufacturerDependency) in
            // here resolve dependency injection
            let getDataNetworkingService = resolver.resolve(GetDataNetworkingServiceProtocol.self)!
            let userNetworkingService = resolver.resolve(UserNetworkingServiceProtocol.self)!

            return DetailInfoManufacturerInteractor(dependency.manufacturer,
                                                    getDataNetworkingService: getDataNetworkingService,
                                                    userNetworkingService: userNetworkingService)
        }

        container.register(DetailInfoManufacturerViewOutputProtocol.self) { _ in
            let presenter = DetailInfoManufacturerPresenter()
            return presenter
        }

        // swiftlint: disable force_cast
        container.register(
            DetailInfoManufacturerViewController.self
        ) { (resolver, dependency: DetailInfoManufacturerDependency) in
            let view = DetailInfoManufacturerViewController()
            let presenter = resolver.resolve(
                DetailInfoManufacturerViewOutputProtocol.self) as! DetailInfoManufacturerPresenter
            let interactor = resolver.resolve(DetailInfoManufacturerInteractorInputProtocol.self,
                                       argument: dependency) as! DetailInfoManufacturerInteractor
            let router = resolver.resolve(DetailInfoManufacturerRouterProtocol.self, argument: dependency)!

            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter

            presenter.router = router
            return view
        }
        // swiftlint: enable force_cast
    }
}
