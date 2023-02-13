//
//
//  TobaccoListAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import Foundation
import Swinject

struct TobaccoListDependency {
    var appRouter: AppRouterProtocol
    var isAdminMode: Bool
    var filter: TobaccoListFilters
}

class TobaccoListAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TobaccoListRouterProtocol.self) { (_, dependency: TobaccoListDependency) in
            let router = TobaccoListRouter(dependency.appRouter)
            return router
        }

        container.register(TobaccoListInteractorInputProtocol.self) { (resolver, dependency: TobaccoListDependency) in
            // here resolve dependency injection
            let getDataManager = resolver.resolve(DataManagerProtocol.self)!
            let getImageManager = resolver.resolve(ImageManagerProtocol.self)!
            let updateDataManager = resolver.resolve(ObserverProtocol.self)!

            return TobaccoListInteractor(dependency.isAdminMode,
                                         filter: dependency.filter,
                                         getDataManager: getDataManager,
                                         getImageManager: getImageManager,
                                         updateDataManager: updateDataManager)
        }

        container.register(TobaccoListViewOutputProtocol.self) { _ in
            let presenter = TobaccoListPresenter()
            return presenter
        }

        // swiftlint: disable force_cast
        container.register(TobaccoListViewController.self) { (resolver, dependency: TobaccoListDependency) in
            let view = TobaccoListViewController()
            let presenter = resolver.resolve(TobaccoListViewOutputProtocol.self) as! TobaccoListPresenter
            let interactor = resolver.resolve(TobaccoListInteractorInputProtocol.self,
                                              argument: dependency) as! TobaccoListInteractor
            let router = resolver.resolve(TobaccoListRouterProtocol.self, argument: dependency)!

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
