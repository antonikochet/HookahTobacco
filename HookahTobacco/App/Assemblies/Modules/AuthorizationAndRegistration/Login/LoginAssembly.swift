//
//
//  LoginAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//
//

import Foundation
import Swinject

struct LoginDependency {
    var appRouter: AppRouterProtocol
}

class LoginAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LoginRouterProtocol.self) { (_, dependency: LoginDependency) in
            let router = LoginRouter(dependency.appRouter)
            return router
        }

        container.register(LoginInteractorInputProtocol.self) { resolver in
            // here resolve dependency injection
            let authService = resolver.resolve(AuthServiceProtocol.self)!
            return LoginInteractor(authService: authService)
        }

        container.register(LoginViewOutputProtocol.self) { _ in
            let presenter = LoginPresenter()
            return presenter
        }

        // swiftlint: disable force_cast
        container.register(LoginViewController.self) { (resolver, dependency: LoginDependency) in
            let view = LoginViewController()
            let presenter = resolver.resolve(LoginViewOutputProtocol.self) as! LoginPresenter
            let interactor = resolver.resolve(LoginInteractorInputProtocol.self) as! LoginInteractor
            let router = resolver.resolve(LoginRouterProtocol.self, argument: dependency)!

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
