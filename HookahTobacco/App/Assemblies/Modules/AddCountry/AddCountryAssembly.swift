//
//
//  AddCountryAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.08.2023.
//
//

import Foundation
import Swinject

struct AddCountryDependency {
    var appRouter: AppRouterProtocol
    var delegate: AddCountryOutputModule?
}

class AddCountryAssembly: Assembly {
    func assemble(container: Container) {

        container.register(AddCountryRouterProtocol.self) { (_, dependency: AddCountryDependency) in
            let router = AddCountryRouter(dependency.appRouter)
            return router
        }

        container.register(AddCountryInteractorInputProtocol.self) { resolver in
            // here resolve dependency injection
            let getDataManager = resolver.resolve(DataManagerProtocol.self)!
            let setDataManager = resolver.resolve(AdminDataManagerProtocol.self)!
            return AddCountryInteractor(getDataManager: getDataManager,
                                        setDataManager: setDataManager)
        }

        container.register(AddCountryViewOutputProtocol.self) { (_, dependency: AddCountryDependency)  in
            let presenter = AddCountryPresenter()
            presenter.delegate = dependency.delegate
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(AddCountryViewController.self) { (resolver, dependency: AddCountryDependency) in
            let view = AddCountryViewController()
            let presenter = resolver.resolve(
                AddCountryViewOutputProtocol.self,
                argument: dependency
            ) as! AddCountryPresenter
            let interactor = resolver.resolve(AddCountryInteractorInputProtocol.self) as! AddCountryInteractor
            let router = resolver.resolve(AddCountryRouterProtocol.self, argument: dependency)!

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
