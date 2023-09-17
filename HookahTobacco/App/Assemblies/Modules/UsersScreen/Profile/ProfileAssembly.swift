//
//
//  ProfileAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 05.01.2023.
//
//

import Foundation
import Swinject

struct ProfileDependency {
    var appRouter: AppRouterProtocol
}

class ProfileAssembly: Assembly {
    func assemble(container: Container) {

        container.register(ProfileRouterProtocol.self) { (_, dependency: ProfileDependency) in
            let router = ProfileRouter(dependency.appRouter)
            return router
        }

        container.register(ProfileInteractorInputProtocol.self) { resolver in
            // here resolve dependency injection
            let authService = resolver.resolve(AuthServiceProtocol.self)!
            let userService = resolver.resolve(UserNetworkingServiceProtocol.self)!
            return ProfileInteractor(authService: authService,
                                     userService: userService)
        }

        container.register(ProfileViewOutputProtocol.self) { _ in
            let presenter = ProfilePresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(ProfileViewController.self) { (resolver, dependency: ProfileDependency) in
            let view = ProfileViewController()
            let presenter = resolver.resolve(ProfileViewOutputProtocol.self) as! ProfilePresenter
            let interactor = resolver.resolve(ProfileInteractorInputProtocol.self) as! ProfileInteractor
            let router = resolver.resolve(ProfileRouterProtocol.self, argument: dependency)!

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
