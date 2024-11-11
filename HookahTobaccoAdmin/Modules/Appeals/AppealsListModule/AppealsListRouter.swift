//
//
//  AppealsListRouter.swift
//  HookahTobaccoAdmin
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import UIKit
import HookahTobaccoCoreAdmin

protocol AppealsListRouterProtocol: RouterProtocol {
    func showDetailAppeal(_ appeal: AppealEntity)
}

class AppealsListRouter: AppealsListRouterProtocol {
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showDetailAppeal(_ appeal: AppealEntity) {
        let data = DetailAppealDataModule(appeal: appeal)
        appRouter.pushViewController(module: DetailAppealModule.self, moduleData: data, animateDisplay: true)
    }
}
