//
//
//  RegistrationAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.12.2022.
//
//

import Foundation
import Swinject

struct RegistrationDependency {
    var appRouter: AppRouterProtocol
}

class RegistrationAssembly: Assembly {
    func assemble(container: Container) {

        container.register(RegistrationRouterProtocol.self) { (_, dependency: RegistrationDependency) in
            let router = RegistrationRouter(dependency.appRouter)
            return router
        }

        container.register(RegistrationInteractorInputProtocol.self) { resolver in
            // here resolve dependency injection
            let registrationService = resolver.resolve(RegistrationServiceProtocol.self)!

            return RegistrationInteractor(registrationService: registrationService)
        }

        container.register(RegistrationViewOutputProtocol.self) { _ in
            let presenter = RegistrationPresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(RegistrationViewController.self) { (resolver, dependency: RegistrationDependency) in
            let view = RegistrationViewController()
            let presenter = resolver.resolve(RegistrationViewOutputProtocol.self) as! RegistrationPresenter
            let interactor = resolver.resolve(RegistrationInteractorInputProtocol.self) as! RegistrationInteractor
            let router = resolver.resolve(RegistrationRouterProtocol.self, argument: dependency)!

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
