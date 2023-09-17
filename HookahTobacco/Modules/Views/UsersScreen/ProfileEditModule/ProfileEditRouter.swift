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
    func dismissEditProfileView(_ user: UserProtocol?)
    func showDatePickerView(date: Date?,
                            title: String?,
                            minDate: Date?,
                            maxDate: Date?,
                            delegate: DatePickerOutputModule?)
    func showSexView(title: String?,
                     items: [String],
                     selectedIndex: Int?,
                     output: SelectListBottomSheetOutputModule?)
}

protocol ProfileEditOutputModule: AnyObject {
    func receivedUpdateUser(_ user: UserProtocol)
}

class ProfileEditRouter: ProfileEditRouterProtocol {
    // MARK: - Public properties
    var appRouter: AppRouterProtocol
    weak var output: ProfileEditOutputModule?

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showProfileView() {
        appRouter.presentView(module: ProfileModule.self, moduleData: nil, animated: true)
    }

    func dismissEditProfileView(_ user: UserProtocol?) {
        if let user {
            output?.receivedUpdateUser(user)
        }
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

    func showSexView(title: String?,
                     items: [String],
                     selectedIndex: Int?,
                     output: SelectListBottomSheetOutputModule?) {
        let data = SelectListBottomSheetDataModule(title: title,
                                                   items: items,
                                                   selectedIndex: selectedIndex,
                                                   output: output)
        appRouter.presentViewModally(module: SelectListBottomSheetModule.self, moduleData: data)
    }
}
