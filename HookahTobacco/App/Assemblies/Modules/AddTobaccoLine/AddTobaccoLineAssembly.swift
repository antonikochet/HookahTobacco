//
//
//  AddTobaccoLineAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.08.2023.
//
//

import Foundation
import Swinject

struct AddTobaccoLineDependency {
    var appRouter: AppRouterProtocol
    var manufacturerId: Int
    var tobaccoLine: TobaccoLine?
    var delegate: AddTobaccoLineOutputModule?
}

class AddTobaccoLineAssembly: Assembly {
    func assemble(container: Container) {

        container.register(AddTobaccoLineRouterProtocol.self) { (_, dependency: AddTobaccoLineDependency) in
            let router = AddTobaccoLineRouter(dependency.appRouter)
            router.delegate = dependency.delegate
            return router
        }

        container.register(
            AddTobaccoLineInteractorInputProtocol.self
        ) { (resolver, dependency: AddTobaccoLineDependency) in
            // here resolve dependency injection
            let setDataManager = resolver.resolve(AdminDataManagerProtocol.self)!
            return AddTobaccoLineInteractor(manufacturerId: dependency.manufacturerId,
                                            tobaccoLine: dependency.tobaccoLine,
                                            setDataManager: setDataManager)
        }

        container.register(AddTobaccoLineViewOutputProtocol.self) { _ in
            let presenter = AddTobaccoLinePresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(AddTobaccoLineViewController.self) { (resolver, dependency: AddTobaccoLineDependency) in
            let view = AddTobaccoLineViewController()
            let presenter = resolver.resolve(AddTobaccoLineViewOutputProtocol.self) as! AddTobaccoLinePresenter
            let interactor = resolver.resolve(
                AddTobaccoLineInteractorInputProtocol.self,
                argument: dependency
            ) as! AddTobaccoLineInteractor
            let router = resolver.resolve(AddTobaccoLineRouterProtocol.self, argument: dependency)!

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
