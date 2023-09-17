//
//
//  SelectListBottomSheetAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 14.09.2023.
//
//

import Foundation
import Swinject

struct SelectListBottomSheetDependency {
    var appRouter: AppRouterProtocol
    var title: String?
    var items: [String]
    var selectedIndex: Int?
    var output: SelectListBottomSheetOutputModule?
}

class SelectListBottomSheetAssembly: Assembly {
    func assemble(container: Container) {

        container.register(
            SelectListBottomSheetRouterProtocol.self
        ) { (_, dependency: SelectListBottomSheetDependency) in
            let router = SelectListBottomSheetRouter(dependency.appRouter)
            router.output = dependency.output
            return router
        }

        container.register(
            SelectListBottomSheetInteractorInputProtocol.self
        ) { (_, dependency: SelectListBottomSheetDependency) in
            // here resolve dependency injection

            return SelectListBottomSheetInteractor(title: dependency.title,
                                                   items: dependency.items,
                                                   selectedItemIndex: dependency.selectedIndex)
        }

        container.register(SelectListBottomSheetViewOutputProtocol.self) { _ in
            let presenter = SelectListBottomSheetPresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(
            SelectListBottomSheetViewController.self
        ) { (resolver, dependency: SelectListBottomSheetDependency) in
            let view = SelectListBottomSheetViewController()
            let presenter = resolver.resolve(
                SelectListBottomSheetViewOutputProtocol.self
            ) as! SelectListBottomSheetPresenter
            let interactor = resolver.resolve(
                SelectListBottomSheetInteractorInputProtocol.self, argument: dependency
            ) as! SelectListBottomSheetInteractor
            let router = resolver.resolve(SelectListBottomSheetRouterProtocol.self, argument: dependency)!

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
