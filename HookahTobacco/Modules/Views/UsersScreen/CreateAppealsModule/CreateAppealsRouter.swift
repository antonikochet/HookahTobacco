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
    func popView(title: String, message: String, image: UIImage?, titleForAction: String)
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

    func popView(title: String, message: String, image: UIImage?, titleForAction: String) {
        appRouter.popViewConroller(animated: true) { [appRouter] in
            let item = SuccessBottomSheetViewItem(
                title: title,
                message: message,
                image: image,
                primaryAction: ActionWithTitle(title: titleForAction, action: { [appRouter] in
                    appRouter.dismissView(animated: true, completion: nil)
                }),
                secondaryAction: nil)
            let data = SuccessBottomSheetDataModule(item: item)
            appRouter.presentViewModally(module: SuccessBottomSheetModule.self, moduleData: data)
        }
    }

    func showAlertSheet(title: String?, message: String?, actions: [AlertSheetAction]) {
        appRouter.presentAlert(type: .sheet(title: title, message: message, actions: actions), completion: nil)
    }
}
