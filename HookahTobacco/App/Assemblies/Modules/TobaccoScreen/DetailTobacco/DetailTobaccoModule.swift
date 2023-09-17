//
//
//  DetailTobaccoModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 25.11.2022.
//
//

import UIKit

struct DetailTobaccoDataModule: DataModuleProtocol {
    let tobacco: Tobacco
}

class DetailTobaccoModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        if let data = data as? DetailTobaccoDataModule {
            let dependency = DetailTobaccoDependency(appRouter: appRouter, tobacco: data.tobacco)
            return appRouter.resolver.resolve(DetailTobaccoViewController.self,
                                              argument: dependency)
        }
        print("В DetailTobaccoModule не были переданы необходимые данные")
        return nil
    }
}
