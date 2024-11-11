//
//
//  AddTasteAssembly.swift
//  HookahTobaccoAdmin
//
//  Created by антон кочетков on 15.11.2022.
//
//

import Foundation
import Swinject
import HookahTobaccoCore
import HookahTobaccoCoreAdmin

struct AddTasteDependency {
    var appRouter: AppRouterProtocol
    var taste: Taste?
    var outputModule: AddTasteOutputModule?
}

class AddTasteAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AddTasteRouterProtocol.self) { (_, dependency: AddTasteDependency) in
            let router = AddTasteRouter(dependency.appRouter)
            router.outputModule = dependency.outputModule
            return router
        }

        container.register(AddTasteInteractorInputProtocol.self) { (resolver, dependency: AddTasteDependency) in
            // here resolve dependency injection
            let tasteRepo = resolver.resolve(TasteRepoProtocol.self)!
            let tasteTypeRepo = resolver.resolve(TasteTypeRepoProtocol.self)!
            let adminTasteRepo = resolver.resolve(AdminTasteRepoProtocol.self)!
            let adminTasteTypeRepo = resolver.resolve(AdminTasteTypeRepoProtocol.self)!

            return AddTasteInteractor(dependency.taste,
                                      tasteRepo: tasteRepo,
                                      tasteTypeRepo: tasteTypeRepo, 
                                      adminTasteRepo: adminTasteRepo,
                                      adminTasteTypeRepo: adminTasteTypeRepo)
        }

        container.register(AddTasteViewOutputProtocol.self) { _ in
            let presenter = AddTastePresenter()
            return presenter
        }

        // swiftlint: disable force_cast
        container.register(AddTasteViewController.self) { (resolver, dependency: AddTasteDependency) in
            let view = AddTasteViewController()
            let presenter = resolver.resolve(AddTasteViewOutputProtocol.self) as! AddTastePresenter
            let interactor = resolver.resolve(AddTasteInteractorInputProtocol.self,
                                              argument: dependency) as! AddTasteInteractor
            let router = resolver.resolve(AddTasteRouterProtocol.self, argument: dependency) as! AddTasteRouter

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
