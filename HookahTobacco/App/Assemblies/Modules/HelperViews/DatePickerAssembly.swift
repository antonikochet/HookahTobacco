//
//
//  DatePickerAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 15.08.2023.
//
//

import Foundation
import Swinject

struct DatePickerDependency {
    var appRouter: AppRouterProtocol
    var dateValue: Date?
    var title: String?
    var minDate: Date?
    var maxDate: Date?
    var delegate: DatePickerOutputModule?
}

class DatePickerAssembly: Assembly {
    func assemble(container: Container) {

        container.register(DatePickerRouterProtocol.self) { (_, dependency: DatePickerDependency) in
            let router = DatePickerRouter(dependency.appRouter)
            router.output = dependency.delegate
            return router
        }

        container.register(DatePickerInteractorInputProtocol.self) { (_, dependency: DatePickerDependency) in
            // here resolve dependency injection

            return DatePickerInteractor(dateValue: dependency.dateValue,
                                        title: dependency.title,
                                        minDate: dependency.minDate,
                                        maxDate: dependency.maxDate)
        }

        container.register(DatePickerViewOutputProtocol.self) { _ in
            let presenter = DatePickerPresenter()
            return presenter
        }

        // swiftlint:disable force_cast
        container.register(DatePickerViewController.self) { (resolver, dependency: DatePickerDependency) in
            let view = DatePickerViewController()
            let presenter = resolver.resolve(DatePickerViewOutputProtocol.self) as! DatePickerPresenter
            let interactor = resolver.resolve(
                DatePickerInteractorInputProtocol.self, argument: dependency
            ) as! DatePickerInteractor
            let router = resolver.resolve(DatePickerRouterProtocol.self, argument: dependency)!

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
