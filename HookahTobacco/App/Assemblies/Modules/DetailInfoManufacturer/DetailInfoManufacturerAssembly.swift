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
            let getDataManager = resolver.resolve(DataManagerProtocol.self)!
            let getImageManager = resolver.resolve(ImageManagerProtocol.self)!

            return DetailInfoManufacturerInteractor(dependency.manufacturer,
                                                    getDataManager: getDataManager,
                                                    getImageManager: getImageManager)
        }

        container.register(DetailInfoManufacturerViewOutputProtocol.self) { _ in
            let presenter = DetailInfoManufacturerPresenter()
            return presenter
        }

        // swiftlint: disable force_cast
        container.register(
            DetailInfoManufacturerViewController.self
        ) { (r, dependency: DetailInfoManufacturerDependency) in
            let view = DetailInfoManufacturerViewController()
            let presenter = r.resolve(
                DetailInfoManufacturerViewOutputProtocol.self) as! DetailInfoManufacturerPresenter
            let interactor = r.resolve(DetailInfoManufacturerInteractorInputProtocol.self,
                                       argument: dependency) as! DetailInfoManufacturerInteractor
            let router = r.resolve(DetailInfoManufacturerRouterProtocol.self, argument: dependency)!

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
