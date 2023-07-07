//
//
//  AddManufacturerAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//
//

import Foundation
import Swinject

struct AddManufacturerDependency {
    var appRouter: AppRouterProtocol
    var manufacturer: Manufacturer?
    var delegate: AddManufacturerOutputModule?
}

class AddManufacturerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AddManufacturerRouterProtocol.self) { (_, dependency: AddManufacturerDependency) in
            let router = AddManufacturerRouter(dependency.appRouter)
            return router
        }

        container.register(AddManufacturerInteractorInputProtocol.self
        ) { (resolver, dependency: AddManufacturerDependency) in
            // here resolve dependency injection
            let setDataManager = resolver.resolve(AdminDataManagerProtocol.self)!
            if let manufacturer = dependency.manufacturer {
                let getImageManager = resolver.resolve(GetImageNetworkingServiceProtocol.self)!
                return AddManufacturerInteractor(manufacturer,
                                                 setDataManager: setDataManager,
                                                 getImageManager: getImageManager)
            }
            return AddManufacturerInteractor(setDataManager: setDataManager)
        }

        container.register(AddManufacturerViewOutputProtocol.self) { _ in
            let presenter = AddManufacturerPresenter()
            return presenter
        }

        // swiftlint: disable force_cast
        container.register(AddManufacturerViewController.self
        ) { (resolver, dependency: AddManufacturerDependency) in
            let view = AddManufacturerViewController()
            let presenter = resolver.resolve(AddManufacturerViewOutputProtocol.self) as! AddManufacturerPresenter
            let interactor = resolver.resolve(AddManufacturerInteractorInputProtocol.self,
                                              argument: dependency) as! AddManufacturerInteractor
            let router = resolver.resolve(AddManufacturerRouterProtocol.self,
                                          argument: dependency) as! AddManufacturerRouter

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
