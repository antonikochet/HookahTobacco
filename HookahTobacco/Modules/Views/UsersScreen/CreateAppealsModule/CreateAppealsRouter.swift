//
//
//  CreateAppealsRouter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//
//

import UIKit

protocol CreateAppealsRouterProtocol: RouterProtocol {
    func showSelectTheme(title: String?,
                         items: [String],
                         selectedIndex: Int?,
                         output: SelectListBottomSheetOutputModule?)
    func popView(_ response: CreateAppealResponse)
    func showAlertSheet(title: String?, message: String?, actions: [AlertSheetAction])
}

class CreateAppealsRouter: CreateAppealsRouterProtocol {
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showSelectTheme(title: String?,
                         items: [String],
                         selectedIndex: Int?,
                         output: SelectListBottomSheetOutputModule?) {
        let data = SelectListBottomSheetDataModule(title: title,
                                                   items: items,
                                                   selectedIndex: selectedIndex,
                                                   output: output)
        appRouter.presentViewModally(module: SelectListBottomSheetModule.self, moduleData: data)
    }

    func popView(_ response: CreateAppealResponse) {
        appRouter.popViewConroller(animated: true) { [appRouter] in
            // TODO: - показывать success bottom sheet
        }
    }

    func showAlertSheet(title: String?, message: String?, actions: [AlertSheetAction]) {
        appRouter.presentAlert(type: .sheet(title: title, message: message, actions: actions), completion: nil)
    }
}
