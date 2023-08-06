//
//
//  AddTastesAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.11.2022.
//
//

import Foundation
import Swinject

struct AddTastesDependency {
    var appRouter: AppRouterProtocol
    var selectedTastes: SelectedTastes
    var outputModule: AddTastesOutputModule?
}

class AddTastesAssembly: Assembly {
    func assemble(container: Container) {

        container.register(AddTastesRouterProtocol.self) { (_, dependency: AddTastesDependency) in
            let router = AddTastesRouter(dependency.appRouter)
            router.outputModule = dependency.outputModule
            return router
        }

        container.register(AddTastesInteractorInputProtocol.self) { (resolver, dependency: AddTastesDependency) in
            // here resolve dependency injection
            let getDataManager = resolver.resolve(GetDataNetworkingServiceProtocol.self)!

            return AddTastesInteractor(selectedTastes: dependency.selectedTastes,
                                       getDataManager: getDataManager)
        }

        container.register(AddTastesViewOutputProtocol.self) { _ in
            let presenter = AddTastesPresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(AddTastesViewController.self) { (resolver, dependency: AddTastesDependency) in
            let view = AddTastesViewController()
            let presenter = resolver.resolve(AddTastesViewOutputProtocol.self) as! AddTastesPresenter
            let interactor = resolver.resolve(
                AddTastesInteractorInputProtocol.self,
                argument: dependency
            ) as! AddTastesInteractor
            let router = resolver.resolve(AddTastesRouterProtocol.self, argument: dependency)!

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
