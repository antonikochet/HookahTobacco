//
//
//  AppealsListRouter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import UIKit

protocol AppealsListRouterProtocol: RouterProtocol {
    func showDetailAppeal(_ appeal: AppealResponse)
}

class AppealsListRouter: AppealsListRouterProtocol {
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showDetailAppeal(_ appeal: AppealResponse) {

    }
}
