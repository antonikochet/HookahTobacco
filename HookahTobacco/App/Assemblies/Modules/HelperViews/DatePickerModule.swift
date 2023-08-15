//
//
//  DatePickerModule.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 15.08.2023.
//
//

import UIKit

struct DatePickerDataModule: DataModuleProtocol {
    var dateValue: Date?
    var title: String?
    var minDate: Date?
    var maxDate: Date?
    var delegate: DatePickerOutputModule?
}

class DatePickerModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var dependency = DatePickerDependency(appRouter: appRouter)
        if let data = data as? DatePickerDataModule {
            dependency.dateValue = data.dateValue
            dependency.title = data.title
            dependency.minDate = data.minDate
            dependency.maxDate = data.maxDate
            dependency.delegate = data.delegate
        }
        return appRouter.resolver.resolve(DatePickerViewController.self,
                                          argument: dependency)
    }
}
