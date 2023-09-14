//
//
//  SelectListBottomSheetRouter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 14.09.2023.
//
//

import UIKit

protocol SelectListBottomSheetRouterProtocol: RouterProtocol {
    func dismissView(_ newSelectedIndex: Int?)
}

protocol SelectListBottomSheetOutputModule: AnyObject {
    func receiveNewData(_ newIndex: Int?)
}

class SelectListBottomSheetRouter: SelectListBottomSheetRouterProtocol {
    // MARK: - Private properties
    var appRouter: AppRouterProtocol
    weak var output: SelectListBottomSheetOutputModule?

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func dismissView(_ newSelectedIndex: Int?) {
        output?.receiveNewData(newSelectedIndex)
        appRouter.dismissView(animated: true, completion: nil)
    }
}
