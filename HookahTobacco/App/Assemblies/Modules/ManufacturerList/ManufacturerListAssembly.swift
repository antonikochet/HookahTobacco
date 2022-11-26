//
//
//  ManufacturerListAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//
//

import Foundation
import Swinject

struct ManufacturerListDependency {
    var appRouter: AppRouterProtocol
    var isAdminMode: Bool
}

class ManufacturerListAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ManufacturerListRouterProtocol.self) { (_, dependency: ManufacturerListDependency) in
            let router = ManufacturerListRouter(dependency.appRouter)
            return router
        }

        container.register(
            ManufacturerListInteractorInputProtocol.self
        ) { (resolver, dependency: ManufacturerListDependency) in
            // here resolve dependency injection
            let getDataManager = resolver.resolve(DataManagerProtocol.self)!
            let getImageManager = resolver.resolve(ImageManagerProtocol.self)!
            let updateDataManager = resolver.resolve(UpdateDataManagerObserverProtocol.self)!

            return ManufacturerListInteractor(dependency.isAdminMode,
                                              getDataManager: getDataManager,
                                              getImageManager: getImageManager,
                                              updateDataManager: updateDataManager)
        }

        container.register(ManufacturerListViewOutputProtocol.self) { _ in
            let presenter = ManufacturerListPresenter()
            return presenter
        }

        // swiftlint: disable force_cast
        container.register(ManufacturerListViewController.self) { (resolver, dependency: ManufacturerListDependency) in
            let view = ManufacturerListViewController()
            let presenter = resolver.resolve(ManufacturerListViewOutputProtocol.self) as! ManufacturerListPresenter
            let interactor = resolver.resolve(ManufacturerListInteractorInputProtocol.self,
                                              argument: dependency) as! ManufacturerListInteractor
            let router = resolver.resolve(ManufacturerListRouterProtocol.self, argument: dependency)!

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
