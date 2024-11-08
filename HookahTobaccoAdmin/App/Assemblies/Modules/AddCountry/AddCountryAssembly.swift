//
//
//  AddCountryAssembly.swift
//  HookahTobaccoAdmin
//
//  Created by Anton Kochetkov on 06.08.2023.
//
//

import Foundation
import Swinject
import HookahTobaccoCore
import HookahTobaccoCoreAdmin

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
            let countryRepo = resolver.resolve(CountryRepoProtocol.self)!
            let adminCountryRepo = resolver.resolve(AdminCountryRepoProtocol.self)!
            return AddCountryInteractor(countryRepo: countryRepo,
                                        adminCountryRepo: adminCountryRepo)
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
