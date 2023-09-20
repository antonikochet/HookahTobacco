//
//
//  DetailAppealRouter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.09.2023.
//
//

import UIKit

protocol DetailAppealRouterProtocol: RouterProtocol {
    func popView()
    func showDetailContent(_ url: URL)
}

class DetailAppealRouter: DetailAppealRouterProtocol {
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func popView() {
        appRouter.popViewConroller(animated: true, completion: nil)
    }

    func showDetailContent(_ url: URL) {

    }
}
