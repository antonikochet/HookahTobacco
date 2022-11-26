//
//
//  DetailTobaccoAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 25.11.2022.
//
//

import Foundation
import Swinject

struct DetailTobaccoDependency {
    var appRouter: AppRouterProtocol
    var tobacco: Tobacco
}

class DetailTobaccoAssembly: Assembly {
    func assemble(container: Container) {

        container.register(DetailTobaccoRouterProtocol.self) { (_, dependency: DetailTobaccoDependency) in
            let router = DetailTobaccoRouter(dependency.appRouter)
            return router
        }

        container.register(DetailTobaccoInteractorInputProtocol.self) {
            (resolver, dependency: DetailTobaccoDependency) in
            // here resolve dependency injection
            let getDataManager = resolver.resolve(DataManagerProtocol.self)!
            return DetailTobaccoInteractor(dependency.tobacco,
                                           getDataManager: getDataManager)
        }

        container.register(DetailTobaccoViewOutputProtocol.self) { _ in
            let presenter = DetailTobaccoPresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(DetailTobaccoViewController.self) { (resolver, dependency: DetailTobaccoDependency) in
            let view = DetailTobaccoViewController()
            let presenter = resolver.resolve(DetailTobaccoViewOutputProtocol.self) as! DetailTobaccoPresenter
            let interactor = resolver.resolve(DetailTobaccoInteractorInputProtocol.self,
                                              argument: dependency) as! DetailTobaccoInteractor
            let router = resolver.resolve(DetailTobaccoRouterProtocol.self, argument: dependency)!

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
