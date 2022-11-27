//
//  AddTobaccoAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 09.10.2022.
//

import Foundation
import Swinject

struct AddTobaccoDependency {
    var appRouter: AppRouterProtocol
    var tobacco: Tobacco?
    var delegate: AddTobaccoOutputModule?
}

class AddTobaccoAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AddTobaccoRouterProtocol.self) { (_, dependency: AddTobaccoDependency) in
            let router = AddTobaccoRouter(dependency.appRouter)
            return router
        }

        container.register(AddTobaccoInteractorInputProtocol.self) { (resolver, dependency: AddTobaccoDependency) in
            let getDataManager = resolver.resolve(GetDataNetworkingServiceProtocol.self)!
            let setDataManager = resolver.resolve(SetDataNetworkingServiceProtocol.self)!
            let setImageManager = resolver.resolve(SetImageNetworkingServiceProtocol.self)!
            return AddTobaccoInteractor(dependency.tobacco,
                                        getDataManager: getDataManager,
                                        setDataManager: setDataManager,
                                        setImageManager: setImageManager)
        }

        container.register(AddTobaccoViewOutputProtocol.self) { _ in
            let presenter = AddTobaccoPresenter()
            return presenter
        }

        // swiftlint: disable force_cast
        container.register(AddTobaccoViewController.self) { (resolver, dependency: AddTobaccoDependency) in
            let view = AddTobaccoViewController()
            let presenter = resolver.resolve(AddTobaccoViewOutputProtocol.self) as! AddTobaccoPresenter
            let interactor = resolver.resolve(AddTobaccoInteractorInputProtocol.self,
                                              argument: dependency) as! AddTobaccoInteractor
            let router = resolver.resolve(AddTobaccoRouterProtocol.self, argument: dependency) as! AddTobaccoRouter

            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter

            presenter.router = router

            router.delegate = dependency.delegate
            return view
        }
        // swiftlint: enable force_cast
    }
}
