//
//
//  DetailAppealModule.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.09.2023.
//
//

import UIKit

struct DetailAppealDataModule: DataModuleProtocol {
    var appeal: AppealResponse
}

class DetailAppealModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        guard let data = data as? DetailAppealDataModule else {
            fatalError("В модуль \(DetailAppealModule.nameModule) не были переданы данные")
        }
        let dependency = DetailAppealDependency(appRouter: appRouter, appeal: data.appeal)
        return appRouter.resolver.resolve(DetailAppealViewController.self,
                                          argument: dependency)
    }
}
