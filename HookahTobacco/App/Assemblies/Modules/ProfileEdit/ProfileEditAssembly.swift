//
//
//  ProfileEditAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 13.08.2023.
//
//

import Foundation
import Swinject

struct ProfileEditDependency {
    var appRouter: AppRouterProtocol
    var isRegistration: Bool
    var user: RegistrationUserProtocol
    let output: ProfileEditOutputModule?
}

class ProfileEditAssembly: Assembly {
    func assemble(container: Container) {

        container.register(ProfileEditRouterProtocol.self) { (_, dependency: ProfileEditDependency) in
            let router = ProfileEditRouter(dependency.appRouter)
            router.output = dependency.output
            return router
        }

        container.register(ProfileEditInteractorInputProtocol.self) { (resolver, dependency: ProfileEditDependency) in
            // here resolve dependency injection
            let registrationService = resolver.resolve(RegistrationServiceProtocol.self)!
            let userNetworkingService = resolver.resolve(UserNetworkingServiceProtocol.self)!
            return ProfileEditInteractor(isRegistration: dependency.isRegistration,
                                         user: dependency.user,
                                         registrationService: registrationService,
                                         userNetworkingService: userNetworkingService)
        }

        container.register(ProfileEditViewOutputProtocol.self) { _ in
            let presenter = ProfileEditPresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(ProfileEditViewController.self) { (resolver, dependency: ProfileEditDependency) in
            let view = ProfileEditViewController()
            let presenter = resolver.resolve(ProfileEditViewOutputProtocol.self) as! ProfileEditPresenter
            let interactor = resolver.resolve(
                ProfileEditInteractorInputProtocol.self,
                argument: dependency
            ) as! ProfileEditInteractor
            let router = resolver.resolve(ProfileEditRouterProtocol.self, argument: dependency)!

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
