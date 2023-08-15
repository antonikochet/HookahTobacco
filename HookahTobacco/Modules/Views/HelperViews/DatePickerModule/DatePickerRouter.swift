//
//
//  DatePickerRouter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 15.08.2023.
//
//

import UIKit

protocol DatePickerRouterProtocol: RouterProtocol {
    func dismissView(_ newDate: Date)
}

protocol DatePickerOutputModule: AnyObject {
    func receivedNewDate(_ newDate: Date)
}

class DatePickerRouter: DatePickerRouterProtocol {
    // MARK: - Public properties
    var appRouter: AppRouterProtocol
    weak var output: DatePickerOutputModule?

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func dismissView(_ newDate: Date) {
        output?.receivedNewDate(newDate)
        appRouter.dismissView(animated: true, completion: nil)
    }
}
