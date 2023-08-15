//
//
//  ProfileEditRouter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 13.08.2023.
//
//

import UIKit

protocol ProfileEditRouterProtocol: RouterProtocol {
    func showProfileView()
    func dismissEditProfileView()
    func showDatePickerView(date: Date?,
                            title: String?,
                            minDate: Date?,
                            maxDate: Date?,
                            delegate: DatePickerOutputModule?)
}

class ProfileEditRouter: ProfileEditRouterProtocol {
    // MARK: - Public properties
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showProfileView() {
        appRouter.presentView(module: ProfileModule.self, moduleData: nil, animated: true)
    }

    func dismissEditProfileView() {
        appRouter.dismissView(animated: true, completion: nil)
    }

    func showDatePickerView(date: Date?,
                            title: String?,
                            minDate: Date?,
                            maxDate: Date?,
                            delegate: DatePickerOutputModule?) {
        let data = DatePickerDataModule(dateValue: date,
                                        title: title,
                                        minDate: minDate,
                                        maxDate: maxDate,
                                        delegate: delegate)
        appRouter.presentViewModally(module: DatePickerModule.self, moduleData: data)
    }
}
